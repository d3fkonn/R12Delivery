require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Tester", email: "test@test.com", password: "password")
    @address = Address.create(street_address: "addr1", city: "city1", postal_code: "zip1")
  end

  test "table has required columns" do
    required_columns = %w[user_id address_id phone email active]
    required_columns.each do |column|
      assert_includes Customer.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      user_id: :integer,
      address_id: :integer,
      phone: :string,
      email: :string,
      active: :boolean
    }

    required_columns.each do |column, data_type|
      assert_equal data_type, Customer.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end


  test "presence validation" do
    required_attributes = {
      user_id: "User",
      address_id: "Address",
      phone: "Phone",
      active: "Active"
    }

    required_attributes.each do |attribute, message|
      customer = Customer.new({ user_id: @user.id, address_id: @address.id, phone: "123123456" })
      customer[attribute] = ""
      assert_not customer.valid?, "#{attribute} should not be empty"
      assert_includes customer.errors.full_messages, "#{message} can't be blank"
    end
  end

  test "customer can have 0..* orders" do
    assert_respond_to Customer.new, :orders, "Customer should have 0..* orders"
  end

end
