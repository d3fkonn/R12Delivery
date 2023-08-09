class Product < ApplicationRecord
  belongs_to :restaurant
  has_many :product_orders
  validates :restaurant_id, :name, :cost, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }

  scope :select_short, -> { select(:id, :name, :cost) }
end
