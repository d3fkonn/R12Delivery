class Courier < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :courier_status
  has_many :orders
  validates :user_id, :address_id, :courier_status_id, :phone, :active,  presence:true
end
