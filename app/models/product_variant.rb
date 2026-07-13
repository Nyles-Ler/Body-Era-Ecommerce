class ProductVariant < ApplicationRecord
  belongs_to :product

  has_many :order_items, dependent: :restrict_with_error

  validates :size, presence: true
  validates :colour, presence: true
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :size, uniqueness: { scope: [:product_id, :colour], message: "and colour combination already exists for this product" }
end
