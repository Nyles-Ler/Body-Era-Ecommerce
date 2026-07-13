class CreateProductVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :size
      t.string :colour
      t.integer :stock_quantity

      t.timestamps
    end

    add_index :product_variants, [:product_id, :size, :colour], unique: true
  end
end
