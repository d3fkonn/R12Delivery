module Api
  class ProductsController < ActionController::Base
    include ApiHelper
    
    # GET /api/products
    def index
      restaurant_id = params[:restaurant]

      if restaurant_id.present?
        restaurant = Restaurant.find_by(id: restaurant_id)
        if restaurant.nil?
          return render_422_error("Invalid restaurant ID")
        end
        @products = restaurant.products.select_short
      else
        @products = Product.select_short
      end

      render json: @products, status: :ok
    end

  end
end