class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  # Feature 4.2.1
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1_000 }
end
