class ProductOrder < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :product_id, :order_id, :product_quantity, :product_unit_cost, presence: true
  validates :product_quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :product_unit_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :product_id, uniqueness: { scope: :order_id }
  validate :product_belongs_to_restaurant

  def product_belongs_to_restaurant
    if product.present? && order.present? && product.restaurant_id != order.restaurant_id
      errors.add(:product, "must belong to the same restaurant as the order")
    end
  end
end
