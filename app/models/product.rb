class Product < ApplicationRecord
  # Feature 4.2.2
  belongs_to :category

  has_many :product_variants, dependent: :destroy
  has_many :product_images, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error
  has_many :reviews, dependent: :destroy

  # Feature 4.2.1
  validates :name, presence: true, length: { maximum: 150 }
  validates :description, presence: true, length: { maximum: 2_000 }
  validates :current_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [true, false] }
end
