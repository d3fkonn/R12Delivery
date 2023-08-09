# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_31_155344) do
  create_table "addresses", force: :cascade do |t|
    t.string "street_address", null: false
    t.string "city", null: false
    t.string "postal_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courier_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "couriers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "address_id", null: false
    t.integer "courier_status_id", default: 1, null: false
    t.string "phone", null: false
    t.string "email"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_couriers_on_address_id"
    t.index ["courier_status_id"], name: "index_couriers_on_courier_status_id"
    t.index ["user_id"], name: "index_couriers_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "address_id", null: false
    t.string "phone", null: false
    t.string "email"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_customers_on_address_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "address_id", null: false
    t.string "phone", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_employees_on_address_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "restaurant_id", null: false
    t.integer "customer_id", null: false
    t.integer "courier_id"
    t.integer "courier_status_id"
    t.integer "order_status_id", null: false
    t.integer "restaurant_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["courier_id"], name: "index_orders_on_courier_id"
    t.index ["courier_status_id"], name: "index_orders_on_courier_status_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["order_status_id"], name: "index_orders_on_order_status_id"
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
  end

  create_table "product_orders", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "order_id", null: false
    t.integer "product_quantity", null: false
    t.integer "product_unit_cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "product_id"], name: "index_product_orders_on_order_id_and_product_id", unique: true
    t.index ["order_id"], name: "index_product_orders_on_order_id"
    t.index ["product_id"], name: "index_product_orders_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "restaurant_id", null: false
    t.string "name", null: false
    t.string "description"
    t.integer "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_products_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "address_id", null: false
    t.string "phone", null: false
    t.string "email"
    t.string "name", null: false
    t.integer "price_range", default: 1, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_restaurants_on_address_id"
    t.index ["user_id"], name: "index_restaurants_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "couriers", "addresses"
  add_foreign_key "couriers", "courier_statuses"
  add_foreign_key "couriers", "users"
  add_foreign_key "customers", "addresses"
  add_foreign_key "customers", "users"
  add_foreign_key "employees", "addresses"
  add_foreign_key "employees", "users"
  add_foreign_key "orders", "courier_statuses"
  add_foreign_key "orders", "couriers"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "order_statuses"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "product_orders", "orders"
  add_foreign_key "product_orders", "products"
  add_foreign_key "products", "restaurants"
  add_foreign_key "restaurants", "addresses"
  add_foreign_key "restaurants", "users"
end
