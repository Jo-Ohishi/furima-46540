class OrderForm
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :token
  attr_accessor :postal_code, :prefecture_id, :city, :street_addresses, :building_name, :phone_number # , :token

  with_options presence: true do
    validates :user_id, :item_id, :token
    validates :city, :street_addresses
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Include hyphen(-)' }
    validates :prefecture_id, numericality: { other_than: 0, message: "can't be blank" }
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'is invalid' }
  end

  def save
    item = Item.find_by(id: item_id)
    if item.nil? || item.order.present?
      errors.add(:base, 'この商品は既に購入済みか、存在しません。')
      return false
    end

    # Payjp.api_key = ENV['PAYJP_SECRET_KEY']

    begin
      # Payjp::Charge.create(
      #   amount: item.price,
      #   card: token,
      #   currency: 'jpy'
      # )

      ActiveRecord::Base.transaction do
        order = Order.create!(
          user_id: user_id,
          item_id: item_id
        )
        ShippingAddress.create!(
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
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each { |msg| errors.add(:base, msg) }
      Rails.logger.error "Validation Error during save: #{e.message}"
      false
    rescue Payjp::PayjpError => e
      errors.add(:base, '決済処理中にエラーが発生しました。カード情報をご確認ください。')
      Rails.logger.error "PAY.JP Error: #{e.message}"
      false
    rescue ActiveRecord::StatementInvalid => e
      errors.add(:base, 'データ保存中に予期せぬデータベースエラーが発生しました。')
      Rails.logger.error "DB Statement Invalid Error: #{e.message}"
      false
    rescue StandardError => e
      errors.add(:base, '処理中に致命的なエラーが発生しました。時間を置いて再度お試しください。')
      Rails.logger.error "Unexpected General Error: #{e.message}"
      false
    end
  end
end
