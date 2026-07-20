class DropProductImages < ActiveRecord::Migration[7.0]
  def change
    drop_table :product_images
  end
end
