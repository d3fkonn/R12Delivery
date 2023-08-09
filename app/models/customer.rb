class Customer < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :orders
  validates :user_id, :address_id, :phone, :active, presence: true
  validates_uniqueness_of :user_id
end
