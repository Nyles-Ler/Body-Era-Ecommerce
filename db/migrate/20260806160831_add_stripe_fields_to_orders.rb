class AddStripeFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :stripe_checkout_session_id, :string
    add_column :orders, :stripe_payment_intent_id, :string
    add_column :orders, :paid_at, :datetime

    add_index :orders, :stripe_checkout_session_id, unique: true
    add_index :orders, :stripe_payment_intent_id, unique: true
  end
end
