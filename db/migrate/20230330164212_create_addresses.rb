class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street_address, null: false
      t.string :city, null: false
      t.string :postal_code, null: false

      t.timestamps
    end
  end
end
