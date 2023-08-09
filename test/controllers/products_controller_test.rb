class ProductsControllerTest < ActionDispatch::IntegrationTest

  test "products route exists and is a GET route" do
    assert_routing({ path: '/api/products', method: :get }, { controller: 'api/products', action: 'index' })
  end

  test "get products without restaurant parameter" do
    get "/api/products"
    assert_response :success
    assert_not_nil @controller.instance_variable_get(:@products)
  end

  test "get products with valid restaurant parameter" do
    user = User.create!(name: "Name 1", email: "test@test.com", password: "password")
    address = Address.create!(street_address: "Street 1", city: "City 1", postal_code: "11111")
    restaurant = Restaurant.create!(user: user, address: address, name: "Test Restaurant", phone: "123456")
    product1 = Product.create!(name: "Product 1", cost: 10, restaurant: restaurant)
    product2 = Product.create!(name: "Product 2", cost: 20, restaurant: restaurant)

    get "/api/products", params: { restaurant: restaurant.id }
    assert_response :success
    assert_not_nil @controller.instance_variable_get(:@products)
    assert_equal [{id: product1.id, name: product1.name, cost: product1.cost},
                  {id: product2.id, name: product2.name, cost: product2.cost}].to_json, response.body
  end

  test "get products with invalid restaurant parameter" do
    get "/api/products", params: { restaurant: 999 }
    assert_response 422
    assert_equal({ error: "Invalid restaurant ID" }.to_json, response.body)
  end

end