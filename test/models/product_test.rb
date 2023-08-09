require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Tester", email: "test@test.com", password: "password")
    @address = Address.create(street_address: "addr1", city: "city1", postal_code: "zip1")
    @restaurant = Restaurant.create(user_id: @user.id, address_id: @address.id, phone: "234858", name: "Burger Fang")
  end

  test "table has required columns" do
    required_columns = %w[restaurant_id name description cost]
    required_columns.each do |column|
      assert_includes Product.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      restaurant_id: :integer,
      name: :string,
      description: :string,
      cost: :integer
    }
    
    required_columns.each do |column, data_type|
      assert_equal data_type, Product.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end

  test "presence validation" do
    required_attributes = {
      restaurant_id: "Restaurant",
      name: "Name",
      cost: "Cost"
    }

    required_attributes.each do |attribute, message|
      product = Product.new({ restaurant_id: @restaurant.id, name: "Tester", cost: 123 })
      product[attribute] = ""
      assert_not product.valid?, "#{attribute} should not be empty"
      assert_includes product.errors.full_messages, "#{message} can't be blank"
    end
  end

  test "product can have 0..* product orders" do
    assert_respond_to Product.new, :product_orders, "Product should have 0..* product orders"
  end

  test "cost should not be negative" do
    product = Product.create(restaurant_id: @restaurant.id, name: "Sushi", cost: -1)
    assert_not product.valid?, "Cost should not be negative"
  end

end
