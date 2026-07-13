class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :review_text

      t.timestamps
    end

    add_index :reviews, [:user_id, :product_id], unique: true
  end
end
