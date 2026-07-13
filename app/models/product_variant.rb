class ProductVariant < ApplicationRecord
  # Feature 4.2.2
  belongs_to :product

  has_many :order_items, dependent: :restrict_with_error

  # Feature 4.2.1
  validates :size, presence: true, length: { maximum: 20 }
  validates :colour, presence: true, length: { maximum: 50 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :size, uniqueness: { scope: [:product_id, :colour], case_sensitive: false, message: "and colour combination already exists for this product" }
end
