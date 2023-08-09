require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Tester", email: "test@test.com", password: "password")
    @address = Address.create(street_address: "addr1", city: "city1", postal_code: "zip1")
  end

  test "table has required columns" do
    required_columns = %w[user_id address_id phone email]
    required_columns.each do |column|
      assert_includes Employee.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      user_id: :integer,
      address_id: :integer,
      phone: :string,
      email: :string
    }

    required_columns.each do |column, data_type|
      assert_equal data_type, Employee.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end


  test "presence validation" do
    required_attributes = {
      user_id: "User",
      address_id: "Address",
      phone: "Phone"
    }

    required_attributes.each do |attribute, message|
      employee = Employee.new({ user_id: @user.id, address_id: @address.id, phone: "123123456" })
      employee[attribute] = ""
      assert_not employee.valid?, "#{attribute} should not be empty"
      assert_includes employee.errors.full_messages, "#{message} can't be blank"
    end
  end

end
