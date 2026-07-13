class AddDetailsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :description, :text
    add_column :products, :price, :decimal, precision: 10, scale: 2
    add_column :products, :stock_quantity, :integer, default: 0, null: false
    add_column :products, :category, :string
    add_column :products, :image_url, :string
    add_column :products, :active, :boolean, default: true, null: false
  end
end
