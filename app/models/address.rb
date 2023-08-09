class Address < ApplicationRecord
    has_one :restaurant
    has_many :customers
    has_many :couriers
    has_many :employees
    validates :street_address, :city, :postal_code, presence: true

    def full_address
        "#{street_address}, #{city}, #{postal_code}"
    end
end
