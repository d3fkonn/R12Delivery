require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
  end

  test "table has required columns" do
    required_columns = %w[name email encrypted_password]
    required_columns.each do |column|
      assert_includes User.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      name: :string,
      email: :string,
      encrypted_password: :string
    }
    
    required_columns.each do |column, data_type|
      assert_equal data_type, User.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end

  test "presence validation" do
    required_attributes = {
      name: "Name",
      email: "Email",
      encrypted_password: "Password",
    }

    required_attributes.each do |attribute, message|
      order = User.new({ name: "Tester", email: "test@test.cocm", encrypted_password: "test"  })
      order[attribute] = ""
      assert_not order.valid?, "#{attribute} should not be empty"
      assert_includes order.errors.full_messages, "#{message} can't be blank"
    end
  end

  test "user can have 0..1 employee" do
    assert_respond_to User.new, :employee, "User should have 0..1 employee"
  end

  test "user can have 0..1 customer" do
    assert_respond_to User.new, :customer, "User should have 0..1 customer"
  end

  test "user can have 0..1 courier" do
    assert_respond_to User.new, :courier, "User should have 0..1 courier"
  end

  test "user can have 0..* restaurants" do
    assert_respond_to User.new, :restaurants, "User should have 0..* restaurants"
  end
end
