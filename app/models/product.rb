class Product < ApplicationRecord
  belongs_to :category

  has_many :product_variants, dependent: :destroy
  has_many :product_images, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :current_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
