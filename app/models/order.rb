class Order < ApplicationRecord
  # Feature 4.2.2
  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :product_variants, through: :order_items

  # Feature 4.2.1

  STATUSES = %w[pending paid processing shipped delivered cancelled].freeze

  validates :subtotal, presence:  true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :order_status, presence: true, inclusion: { in: STATUSES }
end
