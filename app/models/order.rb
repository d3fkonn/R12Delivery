class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer
  belongs_to :courier, optional: true
  belongs_to :order_status
  has_many :product_orders, dependent: :destroy
  validates :restaurant_id, :customer_id, :order_status_id, presence: true
  validates :restaurant_rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true


  def self.user_orders(user_type, user_id)
    case user_type
    when "customer"
      includes(:restaurant, :courier, :product_orders).where(customer_id: user_id)
    when "restaurant"
      includes(:customer, :courier, :product_orders).where(restaurant_id: user_id)
    when "courier"
      includes(:customer, :restaurant, :product_orders).where(courier_id: user_id)
    else
      none
    end
  end

  def total_cost
    product_orders.sum('product_quantity * product_unit_cost')
  end
end
