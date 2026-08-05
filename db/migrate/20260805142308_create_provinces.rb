class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.decimal :gst_rate, precision: 5, scale: 4, default: 0, null: false
      t.decimal :pst_rate, precision: 5, scale: 4, default: 0, null: false
      t.decimal :hst_rate, precision: 5, scale: 4, default: 0, null: false

      t.timestamps
    end

    add_index :provinces, :name, unique: true
    add_index :provinces, :code, unique: true
  end
end
