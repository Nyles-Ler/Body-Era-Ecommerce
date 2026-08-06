class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    signature = request.env["HTTP_STRIPE_SIGNATURE"]
    webhook_secret =
      Rails.application.credentials.dig(:stripe, :webhook_secret)

    begin
      event = Stripe::Webhook.construct_event(
        payload,
        signature,
        webhook_secret
      )
    rescue JSON::ParserError
      head :bad_request
      return
    rescue Stripe::SignatureVerificationError
      head :bad_request
      return
    end

    case event.type
    when "checkout.session.completed"
      complete_order(event.data.object)
    end

    head :ok
  end

  private

  def complete_order(checkout_session)
    return unless checkout_session.payment_status == "paid"

    order = Order.find_by(
      stripe_checkout_session_id: checkout_session.id
    )

    return unless order
    return if order.order_status == "paid"

    order.update!(
      order_status: "paid",
      stripe_payment_intent_id: checkout_session.payment_intent,
      paid_at: Time.current
    )
  end
end