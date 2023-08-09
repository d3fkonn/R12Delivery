class CreateProductOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :product_orders do |t|
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :product_quantity, null: false
      t.integer :product_unit_cost, null: false

      t.timestamps

      t.index ["order_id", "product_id"], unique: true
    end
  end
end
