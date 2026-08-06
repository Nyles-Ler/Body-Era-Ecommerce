ActiveAdmin.register Order do
  permit_params :order_status

  actions :index,:show, :edit, :update

  remove_filter :stripe_checkout_session_id
  remove_filter :stripe_payment_intent_id

  filter :user
  filter :address
  filter :order_status
  filter :subtotal
  filter :tax_amount
  filter :total_amount
  filter :created_at

  form do |f|
  f.semantic_errors

  f.inputs "Order Status" do
    f.input :order_status,
            as: :select,
            collection: Order::STATUSES,
            include_blank: false
     end

  f.actions
  end

end