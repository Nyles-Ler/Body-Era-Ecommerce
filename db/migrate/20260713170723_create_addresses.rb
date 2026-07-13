class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :street_address
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country, default: "Canada", null: false

      t.timestamps
    end
  end
end
