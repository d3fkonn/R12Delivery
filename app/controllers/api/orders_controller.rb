module Api
  class OrdersController < ActionController::Base
    skip_before_action :verify_authenticity_token
    include ApiHelper

  # get api/order/:type/:id
  def index
    type = params[:type]
    id = params[:id]

    case type
    when 'customer'
      customer = Customer.find_by(id: id)
      if customer
        orders = customer.orders
        render json: format_orders_response(orders)
      else
        render json: { error: "Customer with ID #{id} not found." }, status: :not_found
      end
    when 'restaurant'
      restaurant = Restaurant.find_by(id: id)
      if restaurant
        orders = restaurant.orders
        render json: format_orders_response(orders)
      else
        render json: { error: "Restaurant with ID #{id} not found." }, status: :not_found
      end
    when 'courier'
      courier = Courier.find_by(id: id)
      if courier
        orders = courier.orders
        render json: format_orders_response(orders)
      else
        render json: { error: "Courier with ID #{id} not found." }, status: :not_found
      end
    else
      render json: { error: "Invalid type: #{type} or ID: #{id}" }, status: :unprocessable_entity
    end
  end

  def format_orders_response(orders)
    orders.map do |order|
      {
        id: order.id,
        customer_id: order.customer.id,
        customer_name: order.customer&.user&.name,
        customer_address: order.customer&.address&.street_address,
        restaurant_id: order.restaurant.id,
        restaurant_name: order.restaurant&.name,
        restaurant_address: order.restaurant&.address&.street_address,
        courier_id: order.courier.id,
        courier_name: order.courier&.user&.name,
        status: order.courier&.courier_status&.name,
        products: format_products_response(order.product_orders),
      }
    end
  end
  
  def format_products_response(product_orders)
    product_orders.map do |product_order|
      product = product_order.product
      {
        product_id: product.id,
        product_name: product.name,
        quantity: product_order.product_quantity,
        unit_cost: product_order.product_unit_cost,
        total_cost: product_order.product_unit_cost * product_order.product_quantity
      }
    end
  end

    # POST /api/order/:id/status
    def set_status
      status = params[:status]
      id = params[:id]

      unless status.present? && status.in?(["pending", "in progress", "delivered"])
        return render_422_error("Invalid status")
      end

      order = Order.find_by(id: id)
      unless order
        return render_422_error("Invalid order")
      end

      order.update(order_status_id: OrderStatus.find_by(name: status)&.id)
      render json: { status: order.order_status.name }, status: :ok
    end
  end
end
