class Employee < ApplicationRecord
  belongs_to :user
  belongs_to :address
  validates :user_id, :address_id, :phone, presence: true
  validates_uniqueness_of :user_id
end
