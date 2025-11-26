require 'rails_helper'

RSpec.describe Item, type: :model do
  # テストごとに有効な商品インスタンスを作成
  let!(:item) { FactoryBot.build(:item) }

  # --- 正常系テスト ---
  describe '商品出品' do
    it 'すべての必須項目が正しく入力されていれば登録できる' do
      # FactoryBotで生成された有効な@itemの検証
      expect(item).to be_valid
    end
  end

  # --- 必須項目（presence）のバリデーション ---
  describe '商品情報の必須チェック' do
    it '価格(price)が空だと登録できない' do
      item.price = nil
      item.valid?
      expect(item.errors.full_messages).to include('Price can\'t be blank')
    end

    it '商品名(name)が空だと登録できない' do
      item.name = ''
      item.valid?
      expect(item.errors.full_messages).to include('Name can\'t be blank')
    end

    it '商品説明(description)が空だと登録できない' do
      item.description = ''
      item.valid?
      expect(item.errors.full_messages).to include('Description can\'t be blank')
    end

    it '画像(image)が空だと登録できない' do
      # FactoryBotで意図的に画像をnilにする
      item.image = nil
      item.valid?
      expect(item.errors.full_messages).to include('Image can\'t be blank')
    end
  end

  # --- 価格（numericality, range）のバリデーション ---
  describe '価格の数値および範囲チェック' do
    it '価格が300円未満だと登録できない' do
      item.price = 299
      item.valid?
      expect(item.errors.full_messages).to include('Price は、¥300〜¥9,999,999の範囲内の半角数値で入力してください')
    end

    it '価格が9,999,999円を超えると登録できない' do
      item.price = 10_000_000
      item.valid?
      expect(item.errors.full_messages).to include('Price は、¥300〜¥9,999,999の範囲内の半角数値で入力してください')
    end

    it '価格が半角数字以外（例: 全角数字）では登録できない' do
      item.price = '３００'
      item.valid?
      # 💡 このエラーは、'is not a number' か、カスタムメッセージのどちらかになる
      expect(item.errors.full_messages).to include('Price は、¥300〜¥9,999,999の範囲内の半角数値で入力してください')
    end

    it '価格が整数でなければ登録できない（例: 小数）' do
      item.price = 300.5
      item.valid?
      expect(item.errors.full_messages).to include('Price は、¥300〜¥9,999,999の範囲内の半角数値で入力してください')
    end
  end

  # --- Active Hash/選択肢（other_than: 1）のバリデーション ---
  describe 'カテゴリおよびその他の選択項目チェック' do
    context 'category_id' do
      it 'category_idが1（---）だと登録できない' do
        item.category_id = 1
        item.valid?
        expect(item.errors.full_messages).to include('Category を選択してください')
      end
    end

    context 'condition_id' do
      it 'condition_idが1（---）だと登録できない' do
        item.condition_id = 1
        item.valid?
        expect(item.errors.full_messages).to include('Condition を選択してください')
      end
    end

    context 'shipping_fee_payer_id' do
      it 'shipping_fee_payer_idが1（---）だと登録できない' do
        item.shipping_fee_payer_id = 1
        item.valid?
        expect(item.errors.full_messages).to include('Shipping fee payer を選択してください')
      end
    end

    context 'prefecture_id' do
      it 'prefecture_idが1（---）だと登録できない' do
        item.prefecture_id = 1
        item.valid?
        expect(item.errors.full_messages).to include('Prefecture を選択してください')
      end
    end

    context 'shipping_day_id' do
      it 'shipping_day_idが1（---）だと登録できない' do
        item.shipping_day_id = 1
        item.valid?
        expect(item.errors.full_messages).to include('Shipping day を選択してください')
      end
    end
  end
end
