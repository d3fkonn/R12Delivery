require "test_helper"

class CourierTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Tester", email: "test@test.com", password: "password")
    @address = Address.create(street_address: "addr1", city: "city1", postal_code: "zip1")
    @restaurant = Restaurant.create(user_id: @user.id, address_id: @address.id, phone: "234858", name: "Burger Fang")
    @customer = Customer.create(user_id: @user.id, address_id: @address.id, phone: "123123456")
    @courier_status = CourierStatus.create(name: "free")
  end

  test "table has required columns" do
    required_columns = %w[user_id address_id courier_status_id phone active]
    required_columns.each do |column|
      assert_includes Courier.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      user_id: :integer,
      address_id: :integer,
      courier_status_id: :integer,
      phone: :string,
      active: :boolean
    }
    
    required_columns.each do |column, data_type|
      assert_equal data_type, Courier.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end

  test "presence validation" do
    required_attributes = {
      user_id: "User",
      address_id: "Address",
      courier_status_id: "Courier status",
      active: "Active"
    }

    required_attributes.each do |attribute, message|
      order = Courier.new({ user_id: @user.id, address_id: @address.id, courier_status_id: @courier_status.id, phone: "123456" })
      order[attribute] = ""
      assert_not order.valid?, "#{attribute} should not be empty"
      assert_includes order.errors.full_messages, "#{message} can't be blank"
    end
  end

  test "courier can have 0..* orders" do
    assert_respond_to Courier.new, :orders, "Courier should have 0..* orders"
  end

end
