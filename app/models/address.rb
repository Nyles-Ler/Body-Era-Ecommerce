class Address < ApplicationRecord
  belongs_to :user

  validates :street_address, presence: true
  validates :city, presence: true
  validates :province, presence: true
  validates :postal_code, presence: true
  validates :country, presence: true
end
