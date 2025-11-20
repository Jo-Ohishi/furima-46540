# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  # テストデータの準備（各itブロックの前に実行）
  before do
    # FactoryBotを使用してUserインスタンスを生成
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    # --- 正常系テスト ---
    context '新規登録できるとき' do
      it 'すべての必須情報が正しく入力されていれば登録できる' do
        expect(@user).to be_valid
      end

      it 'passwordが6文字以上で英数字混合であれば登録できる' do
        @user.password = 'validP1'
        @user.password_confirmation = 'validP1'
        expect(@user).to be_valid
      end
    end

    # --- 異常系テスト ---
    context '新規登録できないとき' do
      # 必須項目のテスト
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('ニックネームを入力してください')
      end

      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールを入力してください')
      end

      # パスワード関連のテスト
      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
      end

      it 'passwordが数字のみでは登録できない' do
        @user.password = '1234567'
        @user.password_confirmation = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは英字と数字を両方含む必要があります')
      end

      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password = 'Password123'
        @user.password_confirmation = 'Mismatch123'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end

      # 氏名（全角漢字・ひらがな・カタカナ）のテスト
      it 'last_nameが半角文字では登録できない' do
        @user.last_name = 'Smith'
        @user.valid?
        # エラーメッセージはモデルのバリデーションに依存
        expect(@user.errors.full_messages).to include('姓は全角（漢字・ひらがな・カタカナ）で入力してください')
      end

      # 氏名カナ（全角カタカナ）のテスト
      it 'first_name_kanaがひらがなでは登録できない' do
        @user.first_name_kana = 'じょう'
        @user.valid?
        expect(@user.errors.full_messages).to include('名（カナ）は全角カタカナで入力してください')
      end

      it 'last_name_kanaが半角カタカナでは登録できない' do
        @user.last_name_kana = 'ｵｵｲｼ' # 半角カタカナ
        @user.valid?
        expect(@user.errors.full_messages).to include('姓（カナ）は全角カタカナで入力してください')
      end

      # メールアドレスの一意性のテスト
      it '重複したemailが存在する場合登録できない' do
        # 1つ目のユーザーをデータベースに保存
        @user.save
        # 2つ目のユーザーを生成し、同じメールアドレスを設定
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールは既に使用されています')
      end
    end
  end
end
