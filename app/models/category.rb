class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  # Feature 4.2.1
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1_000 }

  # Active Admin
  def self.ransackable_attributes(auth_object = nil)
    [
      "created_at",
      "description",
      "id",
      "name",
      "updated_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["products"]
  end
end
