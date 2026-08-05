class AddCheckoutDetailsToAddressesAndOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :addresses,
                  :province_record,
                  null: true,
                  foreign_key: { to_table: :provinces }

    add_reference :orders,
                  :address,
                  null: true,
                  foreign_key: true

    add_column :orders,
               :gst_rate,
               :decimal,
               precision: 5,
               scale: 4,
               default: 0,
               null: false

    add_column :orders,
               :pst_rate,
               :decimal,
               precision: 5,
               scale: 4,
               default: 0,
               null: false

    add_column :orders,
               :hst_rate,
               :decimal,
               precision: 5,
               scale: 4,
               default: 0,
               null: false

    add_column :orders,
               :gst_amount,
               :decimal,
               precision: 10,
               scale: 2,
               default: 0,
               null: false

    add_column :orders,
               :pst_amount,
               :decimal,
               precision: 10,
               scale: 2,
               default: 0,
               null: false

    add_column :orders,
               :hst_amount,
               :decimal,
               precision: 10,
               scale: 2,
               default: 0,
               null: false
  end
end
