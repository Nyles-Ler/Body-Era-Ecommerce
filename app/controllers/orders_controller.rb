class OrdersController < ApplicationController
  def show
    @order = Order
    .includes(
      :address,
      :user,
      order_items: [:product, :product_variant]
    )
    .find(params[:id])

  clear_paid_cart
  end

  private

  def clear_paid_cart
    stripe_session_id = params[:session_id]

    return if stripe_session_id.blank?
    return unless stripe_session_id == @order.stripe_checkout_session_id

    checkout_session =
      Stripe::Checkout::Session.retrieve(stripe_session_id)

    return unless checkout_session.payment_status == "paid"

    session[:cart] = {}

    redirect_to order_path(@order), status: :see_other

  rescue Stripe::StripeError => error
    Rails.logger.error(
      "Could not verify Strip session while clearing cart: #{error.message}"
    )
  end
end
