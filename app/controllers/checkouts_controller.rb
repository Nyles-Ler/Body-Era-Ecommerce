require "securerandom"

class CheckoutsController < ApplicationController
  before_action :initialize_cart
  before_action :load_cart

  def new
    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    @provinces = Province.order(:name)
  end

  def create
    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    @provinces = Province.order(:name)
    province = Province.find_by(id: checkout_params[:province_id])

    unless province
      flash.now[:alert] = "Please select a valid province."
      render :new, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      user = find_or_create_customer!
      address = create_address!(user, province)
      order = create_order!(user, address, province)
      create_order_items!(order)

      session[:cart] = {}

      redirect_to order_path(order), notice: "Your order has been placed successfully."
    end
  rescue ActiveRecord::RecordInvalid => error
    flash.now[:alert] = error.record.errors.full_messages.to_sentence
    render :new, status: :underprocessable_entity
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end

  def load_cart
    variant_ids = session[:cart].keys

    variants = ProductVariant
      .includes(product: [images_attachments: :blob])
      .where(id: variant_ids)
      .index_by { |variant| variant.id.to_s }

    @cart_items = session[:cart].filter_map do |variant_id, quantity|
      variant = variants[variant_id.to_s]
      next unless variant

      quantity = quantity.to_i
      unit_price = variant.product.current_price
      line_total = unit_price * quantity

      {
        variant: variant,
        product: variant.product,
        quantity: quantity,
        unit_price: unit_price,
        line_total: line_total
      }
    end

    @subtotal = @cart_items.sum { |item| item[:line_total] }
  end

  def find_or_create_customer!
    email = checkout_params[:email].to_s.strip.downcase
    user = User.find_or_initialize_by(email: email)

    user.first_name = checkout_params[:first_name]
    user.last_name = checkout_params[:last_name]
    user.phone_number = checkout_params[:phone_number]

    # Temporary guest password required by has_secure_password
    if user.new_record?
      temporary_password = SecureRandom.hex(16)
      user.password = temporary_password
      user.password_confirmation = temporary_password
    end

    user.save!
    user
  end

  def create_address!(user, province)
    user.addresses.create!(
      street_address: checkout_params[:street_address],
      city: checkout_params[:city],
      province: province.name,
      province_record: province,
      postal_code: checkout_params[:postal_code],
      country: "Canada"
    )
  end

  def create_order!(user, address, province)
    gst_amount = (@subtotal * province.gst_rate).round(2)
    pst_amount = (@subtotal * province.pst_rate).round(2)
    hst_amount = (@subtotal * province.hst_rate).round(2)

    tax_amount = gst_amount + pst_amount + hst_amount
    total_amount = @subtotal + tax_amount

    user.orders.create!(
      address: address,
      subtotal: @subtotal,
      gst_rate: province.gst_rate,
      pst_rate: province.pst_rate,
      hst_rate: province.hst_rate,
      gst_amount: gst_amount,
      pst_amount: pst_amount,
      hst_amount: hst_amount,
      tax_amount: tax_amount,
      total_amount: total_amount,
      order_status: "pending"
    )
  end

  def create_order_items!(order)
    @cart_items.each do |item|
      variant = item[:variant]

      if item[:quantity] > variant.stock_quantity
        raise ActiveRecord::RecordInvalid.new(variant)
      end

      order.order_items.create!(
        product: item[:product],
        product_variant: variant,
        quantity: item[:quantity],
        unit_price: item[:unit_price],
        line_total: item[:line_total]
      )
    end
  end

  def checkout_params
    params.require(:checkout).permit(
      :first_name,
      :last_name,
      :email,
      :phone_number,
      :street_address,
      :city,
      :province_id,
      :postal_code
    )
  end
end
