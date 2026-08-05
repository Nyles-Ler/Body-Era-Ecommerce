class OrdersController < ApplicationController
  def show
    @order = Order
    .includes(
      :address,
      :user,
      order_items: [:product, :product_variant]
    )
    .find(params[:id])
  end
end
