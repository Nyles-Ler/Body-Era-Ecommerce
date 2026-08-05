class OrderItem < ApplicationRecord
  # Feature 4.2.2 join model
  belongs_to :order
  belongs_to :product
  belongs_to :product_variant

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :line_total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      id
      line_total
      order_id
      product_id
      product_variant_id
      quantity
      unit_price
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      order
      product
      product_variant
    ]
  end
end
