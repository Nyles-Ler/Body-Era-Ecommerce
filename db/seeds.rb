# Feature 1.6

require "csv"

products_file = Rails.root.join("db", "data", "products.csv")

CSV.foreach(products_file, headers: true) do |row|
  category = Category.find_or_create_by!(name: row["category"]) do |new_category|
    new_category.description =
      "#{row['category']} products available from BodyEra Fitness."
  end

  Product.find_or_create_by!(name: row["name"]) do |product|
    product.category = category
    product.description = row["description"]
    product.current_price = row["current_price"]
    product.active =
      ActiveModel::Type::Boolean.new.cast(row["active"])
  end
end

sizes = ["Small", "Medium", "Large", "XL"]
colours = ["Black", "White", "Grey", "Navy"]

Product.find_each do |product|
  sizes.each do |size|
    colours.each do |colour|
      ProductVariant.find_or_create_by!(
        product: product,
        size: size,
        colour: colour
      ) do |variant|
        variant.stock_quantity = rand(5..25)
      end
    end
  end
end

Product.find_each do |product|
  ProductImage.find_or_create_by!(
    product: product,
    image_url: "https://placehold.co/600x600?text=#{ERB::Util.url_encode(product.name)}"
  ) do |image|
    image.alt_text = "#{product.name} product image"
  end
end

puts "Seeded #{Category.count} categories."
puts "Seeded #{Product.count} products."
puts "Seeded #{ProductVariant.count} product variants."
puts "Seeded #{Category.count} categories."
puts "Seeded #{Product.count} products."
puts "Seeded #{ProductVariant.count} product variants."
puts "Seeded #{ProductImage.count} product images."

# Feature 1.1, 1.2 Creates administrator account
AdminUser.find_or_create_by!(email: "admin@bodyera.ca") do |admin|
  admin.password = "password"
  admin.password_confirmation = "password"
end

puts "Seeded admin user."