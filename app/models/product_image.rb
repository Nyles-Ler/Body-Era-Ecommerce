class ProductImage < ApplicationRecord
  belongs_to :product

  validates :image_url, presence: true
  validates :alt_text, presence: true
end
