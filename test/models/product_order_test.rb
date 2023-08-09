require "test_helper"

class ProductOrderTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Tester", email: "test@test.com", password: "password")
    @address = Address.create(street_address: "addr1", city: "city1", postal_code: "zip1")
    @restaurant = Restaurant.create(user_id: @user.id, address_id: @address.id, phone: "234858", name: "Burger Fang")
    @customer = Customer.create(user_id: @user.id, address_id: @address.id, phone: "123123456")
    @order_status = OrderStatus.create(name: "delivered")
    @order = Order.create(restaurant_id: @restaurant.id, customer_id: @customer.id, order_status_id: @order_status.id)
    @product = Product.create(restaurant_id: @restaurant.id, name: "Product 1", cost: 1500)
  end

  test "table has required columns" do
    required_columns = %w[product_id order_id product_quantity product_unit_cost]
    required_columns.each do |column|
      assert_includes ProductOrder.column_names, column, "Column '#{column}' not found"
    end
  end

  test "columns have required data type" do
    required_columns = {
      product_id: :integer,
      order_id: :integer,
      product_quantity: :integer,
      product_unit_cost: :integer
    }
    
    required_columns.each do |column, data_type|
      assert_equal data_type, ProductOrder.column_for_attribute(column).type, "Wrong data type for #{column} column"
    end
  end

  test "presence validation" do
    required_attributes = {
      product_id: "Product",
      order_id: "Order",
      product_quantity: "Product quantity",
      product_unit_cost: "Product unit cost"
    }

    required_attributes.each do |attribute, message|
      product = ProductOrder.new({ product_id: @product.id, order_id: @order.id, product_quantity: 4, product_unit_cost: 250 })
      product[attribute] = ""
      assert_not product.valid?, "#{attribute} should not be empty"
      assert_includes product.errors.full_messages, "#{message} can't be blank"
    end
  end

  test "product quantity should be greater or equal to 1" do
    product_order = ProductOrder.create(product_id: @product.id, order_id: @order.id, product_quantity: 0, product_unit_cost: 1500)
    assert_not product_order.valid?, "Product quantity should be greater or equal to 1"
  end

  test "product unit cost should not be negative" do
    product_order = ProductOrder.create(product_id: @product.id, order_id: @order.id, product_quantity: 5, product_unit_cost: -1)
    assert_not product_order.valid?, "Product unit cost should not be negative"
  end

  test "cannot create two product_orders with the same product_id for the same order" do
    product2 = Product.create(restaurant_id: @restaurant.id, name: "Product 2", description: "Description 2", cost: 20)
    product_order1 = ProductOrder.create(order_id: @order.id, product_id: @product.id, product_quantity: 1, product_unit_cost: @product.cost)
    assert product_order1.valid?
    product_order2 = ProductOrder.new(order_id: @order.id, product_id: product2.id, product_quantity: 1, product_unit_cost: product2.cost)
    assert product_order2.valid?
    product_order3 = ProductOrder.new(order_id: @order.id, product_id: @product.id, product_quantity: 1, product_unit_cost: @product.cost)
    refute product_order3.valid?
    assert_equal ["has already been taken"], product_order3.errors[:product_id], "Should not be able to add the same product to the same order twice"
  end

  test "product must belong to the same restaurant as the order" do
    address2 = Address.create(street_address: "addr2", city: "city2", postal_code: "zip2")
    restaurant2 = Restaurant.create(user_id: @user.id, address_id: address2.id, phone: "234858", name: "Restaurant 2")
    product2 = Product.create(restaurant_id: restaurant2.id, name: "Product 3", cost: 1700)
    product_order = ProductOrder.create(order: @order, product: product2, product_quantity: 1, product_unit_cost: product2.cost)
    refute product_order.valid?
    assert_equal ["Product must belong to the same restaurant as the order"], product_order.errors.full_messages_for(:product)
  end
  
end