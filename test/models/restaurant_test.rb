require "test_helper"

class RestaurantTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Tester", email: "test@test.com", password: "password")
    @address = Address.create(street_address: "addr1", city: "city1", postal_code: "zip1")
    @restaurant = Restaurant.create(user_id: @user.id, address_id: @address.id, phone: "234858", name: "Burger Fang")
  end

  test "table has required columns" do
    required_columns = %w[user_id address_id phone email name price_range active]
    required_columns.each do |column|
      assert_includes Restaurant.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      user_id: :integer,
      address_id: :integer,
      phone: :string,
      email: :string,
      name: :string,
      price_range: :integer,
      active: :boolean
    }
    
    required_columns.each do |column, data_type|
      assert_equal data_type, Restaurant.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end

  test "presence validation" do
    required_attributes = {
      user_id: "User",
      address_id: "Address",
      phone: "Phone",
      name: "Name",
      price_range: "Price range",
      active: "Active"
    }

    required_attributes.each do |attribute, message|
      restaurant = Restaurant.new({ user_id: @user.id, address_id: @address.id, phone: "123123456", name: "Tester" })
      restaurant[attribute] = ""
      assert_not restaurant.valid?, "#{attribute} should not be empty"
      assert_includes restaurant.errors.full_messages, "#{message} can't be blank"
    end
  end

  test "restaurant can have 0..* orders" do
    assert_respond_to Restaurant.new, :orders, "Restaurant should have 0..* orders"
  end

  test "restaurant can have 0..* products" do
    assert_respond_to Restaurant.new, :products, "Restaurant should have 0..* products"
  end

end
