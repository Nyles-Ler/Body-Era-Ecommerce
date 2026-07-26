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

puts "Seeded #{Category.count} categories."
puts "Seeded #{Product.count} products."
puts "Seeded #{ProductVariant.count} product variants."

# Feature 1.1, 1.2 Creates administrator account
AdminUser.find_or_create_by!(email: "admin@bodyera.ca") do |admin|
  admin.password = "password"
  admin.password_confirmation = "password"
end

puts "Seeded admin user."

# Feature 1.4 Edit content of websites about and contact page
contact_page = Page.find_or_initialize_by(slug: "contact")
contact_page.title = "Contact BodyEra"
contact_page.content = <<~TEXT
  We'd love to hear from you!

  Whether you have questions about our products, need help with an order, or want to learn more about BodyEra, we're here to help.

  Email:
  support@bodyera.ca

  Phone:
  (431) 754-3299

  Business Hours:
  Monday to Friday
  9:00 AM to 5:00 PM
TEXT

contact_page.save!

about_page = Page.find_or_initialize_by(slug: "about")
about_page.title = "About BodyEra"
about_page.content = <<~TEXT
  Branded Fitness Apparel

  Welcome to BodyEra, your ultimate destination for all things fitness and wellness! At BodyEra, we believe that a healthy body is the foundation of a happy life. Our mission is to empower individuals to achieve their fitness goals through high-quality products, expert advice, and a supportive community.

  Whether you're a seasoned athlete or just starting your fitness journey, BodyEra has something for everyone. Explore our wide range of fitness apparel designed to help you perform at your best. Our team is dedicated to providing quality products, inspiration, and support to keep you motivated and on track.

  Join us at BodyEra and take the first step towards a healthier, stronger you. Together, we can create a community that celebrates fitness, wellness, and the pursuit of a better lifestyle. Let's embark on this journey to a better body and a better era!
TEXT

about_page.save!

puts "Seeded about and contact page."