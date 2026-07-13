class Review < ApplicationRecord
  # Feature 4.2.2
  belongs_to :user
  belongs_to :product

  # Feature 4.2.1
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :review_text, presence: true, length: { minimum: 5, maximum: 2_000 }
  validates :user_id, uniqueness: { scope: :product_id, message: "has already reviewed this product" }, if: -> { user_id.present? && product_id.present? }
end
