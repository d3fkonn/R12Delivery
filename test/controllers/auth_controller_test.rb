class ApiControllerTest < ActionDispatch::IntegrationTest

  test "login route exists and is a POST route" do
    assert_routing({ path: '/api/login', method: :post }, { controller: 'api/auth', action: 'index' })
  end

  test "post auth with valid credentials" do
    user = User.create(email: 'test@test.com', password: 'good_password', name: "user 1")
    post "/api/login", headers: { "Content-Type": "application/json" }, params: { email: 'test@test.com', password: 'good_password' }.to_json
    assert_response :success
    assert_equal({ success: true, user_id: 1, customer_id: nil, courier_id: nil}.to_json, response.body)
  end

  test "post auth with invalid credentials" do
    post "/api/login", headers: { "Content-Type": "application/json" }, params: { email: 'test@test.com', password: 'bad_password' }.to_json
    assert_response :unauthorized
    assert_equal({ success: false }.to_json, response.body)
  end

end