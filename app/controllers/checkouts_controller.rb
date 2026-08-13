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

    if user_signed_in?
      @checkout_user = current_user
    end
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

    checkout_session = nil

    ActiveRecord::Base.transaction do
      user = find_or_create_customer!
      address = create_address!(user, province)
      order = create_order!(user, address, province)

      create_order_items!(order)

      checkout_session = create_stripe_checkout_session!(order)

      order.update!(
        stripe_checkout_session_id: checkout_session.id
      )
    end

      redirect_to checkout_session.url,
                  allow_other_host: true,
                  status: :see_other
  rescue ActiveRecord::RecordInvalid => error
    flash.now[:alert] = error.record.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  rescue Stripe::StripeError => error
    Rails.logger.error("Stripe checkout error: #{error.message}")

      redirect_to cart_path,
                  alert: "There was an error processing your payment. Please try again."
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
    if user_signed_in?
      current_user.update!(
        first_name: checkout_params[:first_name],
        last_name: checkout_params[:last_name],
        phone_number: checkout_params[:phone_number]
      )

      return current_user
    end

    email = checkout_params[:email].to_s.strip.downcase
    user = User.find_or_initialize_by(email: email)

    user.first_name = checkout_params[:first_name]
    user.last_name = checkout_params[:last_name]
    user.phone_number = checkout_params[:phone_number]

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

    # Stores tax total at checkout so past invoices dont change
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

      # Stores total at checkout so if theres changes, old total wont change
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

  def create_stripe_checkout_session!(order)
    Stripe::Checkout::Session.create(
      mode: "payment",

      payment_method_types: ["card"],

      customer_email: order.user.email,

      client_reference_id: order.id.to_s,

      metadata: {
        order_id: order.id.to_s
      },

      payment_intent_data: {
        metadata: {
          order_id: order.id.to_s
        }
      },

      line_items: stripe_line_items(order),

      success_url: "#{order_url(order)}?session_id={CHECKOUT_SESSION_ID}",

      cancel_url: cart_url
    )
  end

  def stripe_line_items(order)
    product_items = order.order_items.map do |item|
      {
        price_data: {
          currency: "cad",

          product_data: {
            name: item.product.name,

            description: [
              item.product_variant.size,
              item.product_variant.colour
            ].join(" / ")
          },

          unit_amount: (item.unit_price * 100).round
        },

        quantity: item.quantity
      }
    end

    tax_items = []

    if order.gst_amount.positive?
      tax_items << stripe_tax_line_item(
        "GST",
        order.gst_amount
      )
    end

    if order.pst_amount.positive?
      tax_items << stripe_tax_line_item(
        "PST",
        order.pst_amount
      )
    end

    if order.hst_amount.positive?
      tax_items << stripe_tax_line_item(
        "HST",
        order.hst_amount
      )
    end

    product_items + tax_items
  end

  def stripe_tax_line_item(name, amount)
    {
      price_data: {
        currency: "cad",

        product_data: {
          name: "#{name} - Canadian Sales Tax"
        },

        unit_amount: (amount * 100).round
      },

      quantity: 1
    }
  end
end
