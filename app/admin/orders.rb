ActiveAdmin.register Order do
  permit_params :order_status

  remove_filter :stripe_checkout_session_id
  remove_filter :stripe_payment_intent_id

  filter :user
  filter :address
  filter :order_status
  filter :subtotal
  filter :tax_amount
  filter :total_amount
  filter :created_at

end