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
    # 2. 💡 決済成功後: データベースの整合性を保証するためにトランザクションを開始
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

    # 3. 💡 決済APIのエラーを捕捉し、フォームにエラーを追加する
  rescue Payjp::PayjpError => e
    # カード情報の不備や残高不足など、決済関連のエラー
    errors.add(:base, '決済処理中にエラーが発生しました。カード情報をご確認ください。')
    Rails.logger.error "PAY.JP Error: #{e.message}"
    false

    # 4. 💡 データベース（ActiveRecord）の整合性エラーを捕捉する
  rescue ActiveRecord::StatementInvalid => e # 💡 修正点: 存在するクラスに変更し、変数 e を捕捉
    # DBのNOT NULL制約違反など、SQLレベルのエラーを捕捉
    errors.add(:base, 'データ保存中に予期せぬエラーが発生しました。')
    Rails.logger.error "DB Statement Invalid Error: #{e.message}" # 💡 改善点: エラーをログに出力
    false

    # 5. 💡 その他の一般的なエラーを捕捉する
  rescue StandardError => e # 💡 修正点: 変数 e を捕捉
    errors.add(:base, '処理中に致命的なエラーが発生しました。時間を置いて再度お試しください。')
    Rails.logger.error "Unexpected Error: #{e.message}" # 💡 改善点: エラーをログに出力
    false
  end
end
