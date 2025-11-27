require 'rails_helper'

# Formオブジェクトのテストでは、必要な関連モデルをファクトリなどで準備します
RSpec.describe OrderForm, type: :model do
  # 💡 テストデータとして必要な User, Item, Order, Address モデルをFactoryBotで定義済みと仮定します。
  before do
    # テストに必要なレコードを準備
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)

    # 💡 PAY.JP/StripeのAPI呼び出し（Stripe::Charge.createなど）をモック化します。
    # 実際の決済処理をスキップすることで、テストの実行速度と安定性を確保します。
    allow(Payjp::Token).to receive(:create).and_return(PayjpMock.mock_token)
    # または PayjpMockなどを使用
  end

  # フォームオブジェクトのインスタンス化に必要な有効な属性のハッシュを定義
  let(:valid_attributes) do
    {
      user_id: @user.id,
      item_id: @item.id,
      token: 'tok_abcdefghij0000000000000000000', # 有効なテストトークン
      postal_code: '123-4567',
      prefecture_id: 2, # '1'は選択肢として無効なため2以上
      city: '東京都',
      street_addresses: '青山1-1-1',
      building_name: '青山ビル', # 任意項目
      phone_number: '09012345678'
    }
  end

  # ----------------------------------------------------
  # バリデーションテスト (Validation Tests)
  # ----------------------------------------------------

  describe 'バリデーションチェック' do
    context '成功するケース' do
      it 'すべての情報が正しく入力されていれば保存できる' do
        order_form = OrderForm.new(valid_attributes)
        expect(order_form).to be_valid
      end

      it '建物名(building_name)が空でも保存できる' do
        valid_attributes[:building_name] = '' # 任意項目を空にする
        order_form = OrderForm.new(valid_attributes)
        expect(order_form).to be_valid
      end
    end

    context '失敗するケース' do
      it 'user_idが空では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(user_id: nil))
        order_form.valid?
        expect(order_form.errors.full_messages).to include("User can't be blank")
      end

      it 'item_idが空では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(item_id: nil))
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Item can't be blank")
      end

      # --- 決済トークン ---
      it 'tokenが空では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(token: nil))
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Token can't be blank")
      end

      # --- 郵便番号 ---
      it 'postal_codeが空では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(postal_code: nil))
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Postal code can't be blank")
      end

      it 'postal_codeにハイフンが含まれていないと保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(postal_code: '1234567'))
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Postal code はハイフン(-)を含めてください')
      end

      # --- 都道府県 ---
      it 'prefecture_idが空では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(prefecture_id: nil))
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Prefecture can't be blank")
      end

      it 'prefecture_idが1（「--」に相当）では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(prefecture_id: 1))
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Prefecture を選択してください')
      end

      # --- 市区町村と番地 ---
      it 'cityが空では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(city: nil))
        order_form.valid?
        expect(order_form.errors.full_messages).to include("City can't be blank")
      end

      it 'street_addressesが空では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(street_addresses: nil))
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Street addresses can't be blank")
      end

      # --- 電話番号 ---
      it 'phone_numberが空では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(phone_number: nil))
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Phone number can't be blank")
      end

      it 'phone_numberが9桁以下では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(phone_number: '090123456'))
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Phone number は10桁または11桁の半角数字で入力してください')
      end

      it 'phone_numberが12桁以上では保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(phone_number: '090123456789'))
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Phone number は10桁または11桁の半角数字で入力してください')
      end

      it 'phone_numberにハイフンが含まれていると保存できない' do
        order_form = OrderForm.new(valid_attributes.merge(phone_number: '090-1234-567'))
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Phone number は10桁または11桁の半角数字で入力してください')
      end
    end
  end

  # ----------------------------------------------------
  # saveメソッドのテスト (Save Method Tests)
  # ----------------------------------------------------

  describe '#save' do
    let(:order_form) { OrderForm.new(valid_attributes) }

    it 'すべての処理が成功すれば、OrderとAddressが保存される' do
      # Orderモデルのレコード数が1増えることを確認
      expect { order_form.save }.to change { Order.count }.by(1)
                                                          .and change { Address.count }.by(1) # Addressモデルのレコード数が1増えることを確認
    end

    it '保存されたOrderとAddressが正しく関連付いている' do
      order_form.save

      order = Order.last
      address = Address.last

      # Orderレコードの確認
      expect(order.user_id).to eq(@user.id)
      expect(order.item_id).to eq(@item.id)

      # Addressレコードの確認
      expect(address.order_id).to eq(order.id)
      expect(address.postal_code).to eq(valid_attributes[:postal_code])
      expect(address.city).to eq(valid_attributes[:city])
      expect(address.phone_number).to eq(valid_attributes[:phone_number])
    end

    it 'バリデーションエラーがある場合、保存処理が中断されfalseが返る' do
      invalid_form = OrderForm.new(valid_attributes.merge(postal_code: '1234567')) # 無効な郵便番号

      expect { invalid_form.save }.to(not_change { Order.count })
      expect(invalid_form.save).to be_falsey
    end

    # 💡 トランザクションのテスト（片方が失敗した場合、両方ロールバックされること）
    it 'Orderの保存に失敗した場合、Addressも保存されずfalseが返る' do
      # 例：user_idがnilの場合、Order.create!で例外が発生する（DBのNOT NULL制約）
      invalid_form = OrderForm.new(valid_attributes.merge(user_id: nil))

      # OrderもAddressも増えないことを確認
      expect { invalid_form.save }.to not_change { Order.count }
        .and(not_change { Address.count })
      expect(invalid_form.save).to be_falsey
    end
  end
end
