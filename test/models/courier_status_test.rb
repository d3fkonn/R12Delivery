require "test_helper"

class CourierStatusTest < ActiveSupport::TestCase

  test "table has required columns" do
    required_columns = %w[name]
    required_columns.each do |column|
      assert_includes CourierStatus.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      name: :string
    }
    
    required_columns.each do |column, data_type|
      assert_equal data_type, CourierStatus.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end

  test "presence validation" do
    required_attributes = {
      name: "Name"
    }

    required_attributes.each do |attribute, message|
      order_status = CourierStatus.new({ name: "free" })
      order_status[attribute] = ""
      assert_not order_status.valid?, "#{attribute} should not be empty"
      assert_includes order_status.errors.full_messages, "#{message} can't be blank"
    end
  end

  test "courier status can have 0..* couriers" do
    assert_respond_to CourierStatus.new, :couriers, "Courier status can have 0..* couriers"
  end
end