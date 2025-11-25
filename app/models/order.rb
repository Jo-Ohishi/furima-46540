class Order < ApplicationRecord
  attr_accessor :token

  validates :price, presence: true
  validates :token, presence: true

  belongs_to :item
  belongs_to :user
  has_one shipping_address
end
