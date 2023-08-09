# We create a user to be able to login into our back office and test it
erica = User.create!(email: "erica.ger@gmail.com", name: "Erica Ger", password: "password")
erica_address = Address.create!(street_address: "123 CodeBoxx Boulevard", city: "Montreal", postal_code: "H4G52Z")

# Erica is an employee!
Employee.create!(user_id: erica.id, address_id: erica_address.id, phone: "5141231234", email: "erica.ger@codeboxxacademy.com")

# Generate users
20.times do
  User.create!(
    email: Faker::Internet.unique.email,
    name: Faker::Name.unique.name,
    password: "password"
  )
end

# Generate addresses
20.times do
  Address.create!(
    street_address: Faker::Address.street_address,
    city: Faker::Address.city,
    postal_code: Faker::Address.zip_code
  )
end

# Generate employees
2.times do
    Employee.create!(
      user_id: User.left_outer_joins(:employee).where(employee: { id: nil }).sample.id,
      address_id: Address.find(Address.pluck(:id).sample).id,
      phone: Faker::PhoneNumber.phone_number
    )
  end

# Generate customers
10.times do
  Customer.create!(
    user_id: User.left_outer_joins(:customer).where(customer: { id: nil }).sample.id,
    address_id: Address.find(Address.pluck(:id).sample).id,
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.unique.email,
    active: true
  )
end

# Generate courier statuses
courier_statuses = %w[free busy full offline]
courier_statuses.each do |status|
  CourierStatus.create!(name: status)
end

# Generate couriers
8.times do
  Courier.create!(
    user_id: User.left_outer_joins(:courier).where(courier: { id: nil }).sample.id,
    address_id: Address.find(Address.pluck(:id).sample).id,
    courier_status_id: rand(1..courier_statuses.size),
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.unique.email,
    active: true
  )
end

# Generate restaurants
8.times do
  Restaurant.create!(
    user_id: User.find(User.pluck(:id).sample).id,
    address_id: Address.left_outer_joins(:restaurant).where(restaurant: { id: nil }).sample.id,
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.unique.email,
    name: Faker::Restaurant.unique.name,
    price_range: rand(1..3),
    active: true
  )
end

# Generate order statuses
order_statuses = ["pending", "in progress", "delivered"]
order_statuses.each do |status|
  OrderStatus.create!(name: status)
end

# Generate products
Restaurant.all.each do |restaurant|
  rand(4..6).times do
    Product.create!(
      restaurant_id: restaurant.id,
      name: Faker::Food.unique.dish,
      cost: rand(0..20)*100 + rand(0..3)*25 + [00,25,50,75,99].sample
    )
  end
end


# Generate orders
100.times do
  restaurant = Restaurant.find(Restaurant.pluck(:id).sample)
  products = restaurant.products.sample(rand(1..restaurant.products.size))
  customer = Customer.find(Customer.pluck(:id).sample)
  courier = Courier.find(Courier.pluck(:id).sample)
  order = Order.create!(
    restaurant_id: restaurant.id,
    customer_id: customer.id,
    courier_id: courier.id,
    order_status_id: rand(1..order_statuses.size),
    restaurant_rating: [1,2,3,4,4,5,5,5,nil].sample,
  )

  products.each do |product|
    ProductOrder.create!(
      product_id: product.id,
      order_id: order.id,
      product_quantity: rand(1..3),
      product_unit_cost: product.cost
    )
  end
end