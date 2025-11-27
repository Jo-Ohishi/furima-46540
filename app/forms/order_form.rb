class OrderForm
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :token
  attr_accessor :postal_code, :prefecture_id, :city, :street_addresses, :building_name, :phone_number, :token

  with_options presence: true do
    validates :user_id, :item_id, :token
    validates :city, :street_addresses
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: 'はハイフン(-)を含めてください' }
    validates :prefecture_id, numericality: { other_than: 1, message: 'を選択してください' }
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'は10桁または11桁の半角数字で入力してください' }
  end

  def save
    ActiveRecord::Base.transaction do
      order = Order.create!(user_id: user_id, item_id: item_id)
      Address.create!(
        order_id: order.id,
        postal_code: postal_code,
        prefecture_id: prefecture_id,
        city: city,
        street_addresses: street_addresses,
        building_name: building_name,
        phone_number: phone_number
      )
    end
    true
  rescue ActiveRecord::ConstraintError
    false
  rescue StandardError
    false
  end
end
