module Api
  class OrdersController < ActionController::Base
    skip_before_action :verify_authenticity_token
    include ApiHelper

    def create
      restaurant_id, customer_id, products = params.values_at(:restaurant_id, :customer_id, :products)
  
  
      # Validate required parameters
      unless restaurant_id.present? && customer_id.present? && products.present?
        return render_400_error("Restaurant ID, customer ID, and products are required")
      end
  
      restaurant = Restaurant.find_by(id: restaurant_id)
      customer = Customer.find_by(id: customer_id)
  
      # Validate foreign keys exists
      unless restaurant && customer
        return render_422_error("Invalid restaurant or customer ID")
      end
  
      order = Order.create!(restaurant_id: restaurant_id, customer_id: customer_id, order_status_id: OrderStatus.find_by(name: "pending")&.id)
  
      # Validate order
      unless order
       return render_422_error("Failed to create order")
      end
  
      # Validate and create product orders
      products.each do |product_params|
        product = Product.find_by(id: product_params[:id])
        
        unless product
          order.destroy
          return render_422_error("Invalid product ID")
        end
    
        order.product_orders.create!(product_id: product.id, product_quantity: product_params[:quantity].to_i, product_unit_cost: product.cost)
      end
      response_data = {
        order: [order],
        products: format_products_response(order.product_orders)
    }
        render json: response_data, status: :created

      
    end
  # get api/order/:type/:id
  def index
    type = params[:type]
    id = params[:id]

    if type.blank? || id.blank?
      return render json: { error: "Both 'type' and 'id' parameters are required." }, status: :bad_request
    end
  
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
