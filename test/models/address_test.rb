require "test_helper"

class AddressTest < ActiveSupport::TestCase

  test "table has required columns" do
    required_columns = %w[street_address city postal_code]
    required_columns.each do |column|
      assert_includes Address.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      street_address: :string,
      city: :string,
      postal_code: :string
    }

    required_columns.each do |column, data_type|
      assert_equal data_type, Address.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end

  test "presence validation" do
    required_attributes = {
      street_address: "Street address",
      city: "City",
      postal_code: "Postal code"
    }

    required_attributes.each do |attribute, message|
      employee = Address.new({ street_address: "123 CodeBoxx Boulevard", city: "New York", postal_code: "10010" })
      employee[attribute] = ""
      assert_not employee.valid?, "#{attribute} should not be empty"
      assert_includes employee.errors.full_messages, "#{message} can't be blank"
    end
  end

  test "address can have 0..1 restaurant" do
    assert_respond_to Address.new, :restaurant, "Address should have 0..1 restaurant"
  end

  test "address can have 0..* customers" do
    assert_respond_to Address.new, :customers, "Address should have 0..* customers"
  end

  test "address can have 0..* employees" do
    assert_respond_to Address.new, :employees, "Address should have 0..* employees"
  end

  test "address can have 0..* couriers" do
    assert_respond_to Address.new, :couriers, "Address should have 0..* couriers"
  end

end
