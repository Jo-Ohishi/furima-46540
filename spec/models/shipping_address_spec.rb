# require 'rails_helper'

# RSpec.describe ShippingAddress, type: :model do
#   # 💡 フォームオブジェクトとして扱う場合は、外部キーの order_id は不要です。
#   #    ここでは、OrderForm の一部としてバリデーションが実行されることを想定します。
#   # 有効な属性を定義（テストのベースとして使用）
#   let(:valid_attributes) do
#     {
#       postal_code: '123-4567',
#       prefecture_id: 2, # 0以外の有効なID
#       city: '東京都',
#       street_addresses: '青山一丁目1-1',
#       phone_number: '09012345678', # 10桁または11桁
#       building_name: 'ビル名' # 任意項目
#     }
#   end

#   # OrderForm のバリデーションを再現するため、
#   # ShippingAddress は ActiveModel をインクルードしていると仮定します。
#   # Model名が ShippingAddress であるため、Modelを先に定義する必要があります。
#   before(:all) do
#     class ShippingAddress
#       include ActiveModel::Model
#       attr_accessor :postal_code, :prefecture_id, :city, :street_addresses, :building_name, :phone_number

#       with_options presence: true do
#         validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Include hyphen(-)' }
#         validates :prefecture_id, numericality: { other_than: 0, message: "can't be blank" }
#         validates :city
#         validates :street_addresses
#         validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'is invalid' }
#       end
#     end
#   end

#   describe '#validations' do
#     it 'すべての必須項目と有効なフォーマットが存在すれば有効であること' do
#       shipping_address = ShippingAddress.new(valid_attributes)
#       expect(shipping_address).to be_valid
#     end

#     # --- presence: true の必須項目チェック ---

#     context 'presence: true のバリデーション' do
#       it 'postal_code が空では無効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.except(:postal_code))
#         expect(shipping_address).to be_invalid
#         expect(shipping_address.errors.full_messages).to include("Postal code can't be blank")
#       end

#       it 'prefecture_id が空では無効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.except(:prefecture_id))
#         expect(shipping_address).to be_invalid
#         expect(shipping_address.errors.full_messages).to include("Prefecture can't be blank")
#       end
#       it 'phone_number が空では無効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.except(:phone_number))
#         expect(shipping_address).to be_invalid
#         expect(shipping_address.errors.full_messages).to include("Phone number can't be blank")
#       end

#       it 'building_name が空でも有効であること (任意項目の確認)' do
#         shipping_address = ShippingAddress.new(valid_attributes.except(:building_name))
#         expect(shipping_address).to be_valid
#       end
#     end
#     # --- 個別のフォーマットチェック ---

#     context 'postal_code のフォーマットチェック' do
#       it 'ハイフンがないと無効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.merge(postal_code: '1234567'))
#         expect(shipping_address).to be_invalid
#         expect(shipping_address.errors.full_messages).to include('Postal code is invalid. Include hyphen(-)')
#       end
#     end

#     context 'prefecture_id の数値チェック' do
#       it 'prefecture_id が 0 だと無効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.merge(prefecture_id: 0))
#         expect(shipping_address).to be_invalid
#         expect(shipping_address.errors.full_messages).to include("Prefecture can't be blank")
#       end
#     end

#     context 'phone_number のフォーマットチェック' do
#       it '電話番号が9桁以下だと無効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.merge(phone_number: '090123456')) # 9桁
#         expect(shipping_address).to be_invalid
#       end
#       it '電話番号が12桁以上だと無効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.merge(phone_number: '090123456789')) # 12桁
#         expect(shipping_address).to be_invalid
#       end
#       it '電話番号に数字以外が含まれていると無効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.merge(phone_number: '090-1234-5678')) # ハイフン
#         expect(shipping_address).to be_invalid
#       end
#       it '電話番号が10桁だと有効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.merge(phone_number: '0312345678')) # 10桁
#         expect(shipping_address).to be_valid
#       end

#       it '電話番号が11桁だと有効であること' do
#         shipping_address = ShippingAddress.new(valid_attributes.merge(phone_number: '09012345678')) # 11桁
#         expect(shipping_address).to be_valid
#       end
#       it '電話番号にハイフンが含まれている場合、無効であること' do
#         address = ShippingAddress.new(valid_attributes.merge(phone_number: '090-1234-5678'))
#         address.valid?
#         expect(address.errors.full_messages).to include('Phone number is invalid')
#       end
#     end
#   end
# end
