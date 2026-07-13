class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :current_price, precision: 10, scale: 2
      t.boolean :active

      t.timestamps
    end
  end
end
