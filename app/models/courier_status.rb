class CourierStatus < ApplicationRecord
  has_many :couriers
  validates :name, presence: true
end
