class RestaurantsControllerTest < ActionDispatch::IntegrationTest

  test "restaurants route exists and is a GET route" do
    assert_routing({ path: '/api/restaurants', method: :get }, { controller: 'api/restaurants', action: 'index' })
  end

  test "get restaurants with valid parameters" do
    user = User.create!(name: "User 1", email: "test@test.com", password: "password")
    address = Address.create!(street_address: "Street 1", city: "City 1", postal_code: "11111")
    restaurant = Restaurant.create!(user: user, address: address, name: "Restaurant 1", phone: "123456", price_range: 2)
    customer = Customer.create!(user: user, address: address, phone: "123456")
    product = Product.create!(name: "Product 1", cost: 10, restaurant: restaurant)
    order_status = OrderStatus.create!(name: "Order Status 1")
    order = Order.create!(restaurant: restaurant, customer: customer, order_status: order_status, restaurant_rating: 4)
    product_order = ProductOrder.create!(product: product, order: order, product_quantity: 2, product_unit_cost: 300)

    get "/api/restaurants", params: { rating: 4, price_range: 2 }
    assert_response :success
    assert_not_nil @controller.instance_variable_get(:@restaurants)
    assert_equal [{id: restaurant.id, name: restaurant.name, price_range: restaurant.price_range, rating: 4}].to_json, response.body
  end

  test "get restaurants with invalid rating parameter" do
    get "/api/restaurants", params: { rating: 6, price_range: 2 }
    assert_response :unprocessable_entity
    assert_equal "Invalid rating or price range", JSON.parse(response.body)["error"]
  end

  test "get restaurants with invalid price range parameter" do
    get "/api/restaurants", params: { rating: 4, price_range: 4 }
    assert_response :unprocessable_entity
    assert_equal "Invalid rating or price range", JSON.parse(response.body)["error"]
  end

  test "get restaurants with no parameters" do
    get "/api/restaurants"
    assert_response :success
    assert_not_nil @controller.instance_variable_get(:@restaurants)
  end

end