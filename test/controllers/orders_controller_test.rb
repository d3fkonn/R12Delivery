require 'test_helper'
class OrdersControllerTest < ActionDispatch::IntegrationTest

  def setup
    user = User.create!(name: "User 1", email: "test@test.com", password: "password")
    address = Address.create!(street_address: "Street 1", city: "City 1", postal_code: "11111")
    restaurant = Restaurant.create!(user: user, address: address, name: "Restaurant 1", phone: "123456", price_range: 2)
    customer = Customer.create!(user: user, address: address, phone: "123456")
    courier_status = CourierStatus.create(name: "free")
    CourierStatus.create(name: "busy")
    CourierStatus.create(name: "full")
    CourierStatus.create(name: "offline")
    courier = Courier.create!(user: user, address: address, courier_status: courier_status, phone: "123456", email: "test@test.com", active: 1)
    product = Product.create!(name: "Product 1", cost: 10, restaurant: restaurant)
    order_status = OrderStatus.create(name: "pending")
    OrderStatus.create(name: "in progress")
    OrderStatus.create(name: "delivered")
    @order = Order.create!(restaurant: restaurant, customer: customer, courier: courier, order_status: order_status, restaurant_rating: 4)
    
  end

  test "get order customer" do
    id = 1
    type = "customer"
    get "/api/order/#{type}/#{id}"
    assert_response :success
    assert_equal "customer", type
  
    json_response = JSON.parse(response.body)
    puts json_response
    assert_not_empty json_response
    assert_equal id, json_response[0]['customer_id']
  end

  test "get order restaurant" do
    id = 1
    type = "restaurant"
    get "/api/order/#{type}/#{id}"
    assert_response :success
    assert_equal "restaurant", type
  
    json_response = JSON.parse(response.body)
    puts json_response
    assert_not_empty json_response
    assert_equal id, json_response[0]['restaurant_id']
  end

  test "get order courier" do
    id = 1
    type = "courier"
    get "/api/order/#{type}/#{id}"
    assert_response :success
    assert_equal "courier", type
  
    json_response = JSON.parse(response.body)
    puts json_response
    assert_not_empty json_response
    assert_equal id, json_response[0]['courier_id']
  end

  test "update order status to 'pending'" do 
    post "/api/order/#{@order.id}/status", params: { status: "pending" }
    assert_response :success
    assert_equal "pending", @order.reload.order_status.name
  end

  test "update order status to 'in progress'" do
    post "/api/order/#{@order.id}/status", params: { status: "in progress" }
    assert_response :success
    assert_equal "in progress", @order.reload.order_status.name
  end

  test "update order status to 'delivered'" do
    post "/api/order/#{@order.id}/status", params: { status: "delivered" }
    assert_response :success
    assert_equal "delivered", @order.reload.order_status.name
  end

  test "return 422 error for invalid status" do
    post "/api/order/#{@order.id}/status", params: { status: "invalid" }
    assert_response 422
  end

  test "return 422 error for invalid order" do
    post "/api/order/0/status", params: { status: "pending" }
    assert_response 422
  end

  test "post api/orders success" do
    post "/api/orders", params: {
      "restaurant_id" => 1,
      "customer_id" => 1,
      "products" => [
        {
          "id" => 1,
          "quantity" => 1
        }
      ]
    }
    
    assert_response 201
    #Gives error code 201 because it is creating an entry in the table, can rework if a code of specifically 200 is required
  end
  test "post api/orders Invalid productID" do
    post "/api/orders", params: {
      "restaurant_id" => 1,
      "customer_id" => 3,
      "products" => [
        {
          "id" => "Test",
          "quantity" => 1
        },
        {
          "id" => 9999,
          "quantity" => 3
        }
      ]
    }
  assert_response 422
end
  test "post api/orders Invalid Customer ID" do
  post "/api/orders", params:{
    "restaurant_id": 1,
    "customer_id": 2742,
    "products": [
                 {
                   "id"=> 2,
                   "quantity"=> 1
                 },
                 {
                   "id" => 3,
                   "quantity" => 3
                 }
               ]
  }
  assert_response 422
end

  test "post api/orders BLANk" do
  post "/api/orders", params:{
    "restaurant_id": "",
    "customer_id": "",
    "products": [
                 {
                   "id" => "",
                   "quantity" => ""
                 },
                 {
                   "id"=> "",
                   "quantity" => "" 
                 }
               ]
  }
  assert_response 400
end
end