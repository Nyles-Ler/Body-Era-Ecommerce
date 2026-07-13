class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :subtotal
      t.decimal :tax_amount
      t.decimal :total_amount
      t.string :order_status, default: "pending", null: false

      t.timestamps
    end
  end
end
