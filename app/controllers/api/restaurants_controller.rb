module Api
  class RestaurantsController < ActionController::Base
    include ApiHelper

    # GET /api/restaurants
    def index
      rating = params[:rating]
      price_range = params[:price_range]

      if is_number_in_range?(rating, 1, 5) && is_number_in_range?(price_range, 1, 3)
        @restaurants = Restaurant.rating_and_price(rating, price_range)
        render json: @restaurants, status: :ok
      else
        render_422_error("Invalid rating or price range")
      end
    end
  
  end
end