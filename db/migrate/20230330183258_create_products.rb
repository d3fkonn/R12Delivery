class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.integer :cost, null: false

      t.timestamps
    end
  end
end
