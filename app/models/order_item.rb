class OrderItem < ApplicationRecord
  # Feature 4.2.2 join model
  belongs_to :order
  belongs_to :product_variant

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :line_total, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
