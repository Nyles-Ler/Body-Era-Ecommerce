class Address < ApplicationRecord
  # Feature 4.2.2
  belongs_to :user

  belongs_to :province_record,
              class_name: "Province",
              optional: true

  has_many :orders, dependent: :restrict_with_error

  # Feature 4.2.1
  validates :street_address, presence: true, length: { maximum: 150 }
  validates :city, presence: true, length: { maximum: 100 }
  validates :province, presence: true, length: { maximum: 50 }
  validates :postal_code, presence: true, format: { with: /\A[ABCEGHJ-NPRSTUVXY]\d[ABCEGHJ-NPRSTV-Z][ -]?\d[ABCEGHJ-NPRSTV-Z]\d\z/i, message: "must be a valid Canadian postal code" }
  validates :country, presence: true, length: { maximum: 100 }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      city
      country
      created_at
      id
      postal_code
      province
      province_record_id
      street_address
      updated_at
      user_id
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      orders
      province_record
      user
    ]
  end
end
