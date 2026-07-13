require "uri"

class ProductImage < ApplicationRecord
  belongs_to :product

  validates :image_url, presence: true, length: { maximum: 500 }, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid HTTP or HTTPS URL" }
  validates :alt_text, presence: true, length: { maximum: 255 }
end
