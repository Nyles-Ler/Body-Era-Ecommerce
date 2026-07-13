class Address < ApplicationRecord
  # Feature 4.2.2
  belongs_to :user

  # Feature 4.2.1
  validates :street_address, presence: true, length: { maximum: 150 }
  validates :city, presence: true, length: { maximum: 100 }
  validates :province, presence: true, length: { maximum: 50 }
  validates :postal_code, presence: true, format: { with: /\A[ABCEGHJ-NPRSTUVXY]\d[ABCEGHJ-NPRSTV-Z][ -]?\d[ABCEGHJ-NPRSTV-Z]\d\z/i, message: "must be a valid Canadian postal code" }
  validates :country, presence: true, length: { maximum: 100 }
end
