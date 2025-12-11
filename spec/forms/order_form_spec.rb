require 'rails_helper'

RSpec.describe OrderForm, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item) }
  let(:valid_attributes) do
    FactoryBot.attributes_for(:order_form, user_id: user.id, item_id: item.id)
  end
  describe '#validations' do
    it 'すべての必須項目が正しく入力され、フォーマットが有効であれば有効であること' do
      order_form = OrderForm.new(valid_attributes)
      expect(order_form).to be_valid
    end

    it '建物名(building_name)が空でも有効であること' do
      order_form = OrderForm.new(valid_attributes.except(:building_name))
      expect(order_form).to be_valid
    end

    context '必須項目の欠落チェック' do
      it '決済トークン(token)が空だと無効であること' do
        order_form = OrderForm.new(valid_attributes.except(:token))
        expect(order_form).to be_invalid
        expect(order_form.errors.full_messages).to include("Token can't be blank")
      end

      it '市区町村(city)が空だと無効であること' do
        order_form = OrderForm.new(valid_attributes.except(:city))
        expect(order_form).to be_invalid
        expect(order_form.errors.full_messages).to include("City can't be blank")
      end

      it '番地(street_addresses)が空だと無効であること' do
        order_form = OrderForm.new(valid_attributes.except(:street_addresses))
        expect(order_form).to be_invalid
        expect(order_form.errors.full_messages).to include("Street addresses can't be blank")
      end

      it '電話番号(phone_number)が空だと無効であること' do
        order_form = OrderForm.new(valid_attributes.except(:phone_number))
        expect(order_form).to be_invalid
        expect(order_form.errors.full_messages).to include("Phone number can't be blank")
      end
    end

    context '郵便番号のフォーマットチェック' do
      it '郵便番号にハイフンがないと無効であること' do
        order_form = OrderForm.new(valid_attributes.merge(postal_code: '1234567'))
        expect(order_form).to be_invalid
        expect(order_form.errors.full_messages).to include('Postal code is invalid. Include hyphen(-)')
      end

      it '郵便番号が3桁-4桁の形式でないと無効であること' do
        order_form = OrderForm.new(valid_attributes.merge(postal_code: '12-34567'))
        expect(order_form).to be_invalid
      end
    end

    context '都道府県IDの数値チェック' do
      it 'prefecture_id が 0 だと無効であること' do
        order_form = OrderForm.new(valid_attributes.merge(prefecture_id: 0))
        expect(order_form).to be_invalid
        expect(order_form.errors.full_messages).to include("Prefecture can't be blank")
      end
    end

    context '電話番号のフォーマットチェック' do
      it '電話番号が9桁以下だと無効であること' do
        order_form = OrderForm.new(valid_attributes.merge(phone_number: '090123456'))
        expect(order_form).to be_invalid
      end

      it '電話番号が12桁以上だと無効であること' do
        order_form = OrderForm.new(valid_attributes.merge(phone_number: '090123456789'))
        expect(order_form).to be_invalid
      end

      it '電話番号にハイフンが含まれていると無効であること' do
        order_form = OrderForm.new(valid_attributes.merge(phone_number: '090-1234-5678'))
        expect(order_form).to be_invalid
        expect(order_form.errors.full_messages).to include('Phone number is invalid')
      end

      it '電話番号が10桁の半角数値だと有効であること' do
        order_form = OrderForm.new(valid_attributes.merge(phone_number: '0312345678'))
        expect(order_form).to be_valid
      end
      it '電話番号が11桁の半角数値だと有効であること' do
        order_form = OrderForm.new(valid_attributes.merge(phone_number: '09012345678'))
        expect(order_form).to be_valid
      end
    end
  end
end
