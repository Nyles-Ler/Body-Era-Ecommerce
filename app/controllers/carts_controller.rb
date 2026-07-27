class CartsController < ApplicationController
  before_action :initialize_cart
  def show
    variant_ids = session[:cart].keys

    @variants = ProductVariant
    .includes(product: [images_attachments: :blob])
    .where(id: variant_ids)
  end

  def add
    variant = ProductVariant.find(params[:variant_id])
    quantity = params[:quantity].to_i

    quantity = 1 if quantity < 1

    current_quantity = session[:cart][variant.id.to_s].to_i
    new_quantity = current_quantity + quantity

    if new_quantity > variant.stock_quantity
      redirect_to product_path(variant.product),
      alert: "There is not enough stock available."
      return
    end

    session[:cart][variant.id.to_s] = new_quantity

    redirect_to cart_path,
    notice: "#{variant.product.name} was added to your cart."
  end

  def update
    variant = ProductVariant.find(params[:variant_id])
    quantity = params[:quantity].to_i

    if quantity < 1
      redirect_to cart_path,
      alert: "Quantity must be at least 1."
      return
    end

    if quantity > variant.stock_quantity
      redirect_to cart_path,
      alert: "Only #{variant.stock_quantity} are available."
      return
    end

    session[:cart][variant.id.to_s] = quantity

    redirect_to cart_path,
    notice: "Cart quantity was updated."
  end

  def remove
    variant = ProductVariant.find(params[:variant_id])

    session[:cart].delete(variant.id.to_s)

    redirect_to cart_path,
    notice: "#{variant.product.name} was removed from your cart."
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end
end
