require "test_helper"

class OrderStatusTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Tester", email: "test@test.com", password: "password")
    @address = Address.create(street_address: "addr1", city: "city1", postal_code: "zip1")
  end

  test "table has required columns" do
    required_columns = %w[name]
    required_columns.each do |column|
      assert_includes OrderStatus.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      name: :string
    }
    
    required_columns.each do |column, data_type|
      assert_equal data_type, OrderStatus.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end

  test "presence validation" do
    required_attributes = {
      name: "Name"
    }

    required_attributes.each do |attribute, message|
      order_status = OrderStatus.new({ name: "delivered" })
      order_status[attribute] = ""
      assert_not order_status.valid?, "#{attribute} should not be empty"
      assert_includes order_status.errors.full_messages, "#{message} can't be blank"
    end
  end

  test "order status can have 0..* orders" do
    assert_respond_to OrderStatus.new, :orders, "Order status should have 0..* orders"
  end
end
