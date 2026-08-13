class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable,
        :validatable

  # Feature 4.2.2
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :restrict_with_error
  has_many :reviews, dependent: :destroy

  # Feature 4.2.1
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, length: { maximum: 255 }
  validates :phone_number, allow_blank: true, format: { with: /\A[\d\s()+\-]+\z/, message: "contains invalid characters" }, length: { maximum: 25 }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      email
      first_name
      id
      last_name
      phone_number
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      addresses
      orders
      reviews
    ]
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
