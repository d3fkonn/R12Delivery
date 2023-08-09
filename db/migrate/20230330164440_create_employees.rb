class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.references :user, null: false, foreign_key: true, unique: true
      t.references :address, null: false, foreign_key: true
      t.string :phone, null: false
      t.string :email

      t.timestamps
    end
  end
end
 