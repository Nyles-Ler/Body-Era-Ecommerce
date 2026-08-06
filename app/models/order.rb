class Order < ApplicationRecord
  # Feature 4.2.2
  belongs_to :user
  belongs_to :address, optional: true

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :product_variants, through: :order_items

  # Feature 4.2.1

  STATUSES = %w[pending paid processing shipped delivered cancelled].freeze

  validates :subtotal, presence:  true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :order_status, presence: true, inclusion: { in: STATUSES }

    def self.ransackable_attributes(auth_object = nil)
    %w[
      address_id
      created_at
      gst_amount
      gst_rate
      hst_amount
      hst_rate
      id
      order_status
      pst_amount
      pst_rate
      stripe_checkout_session_id
      stripe_payment_intent_id
      subtotal
      tax_amount
      total_amount
      updated_at
      user_id
    ]
    end

  def self.ransackable_associations(auth_object = nil)
    %w[
      address
      order_items
      product_variants
      products
      user
    ]
  end
end
