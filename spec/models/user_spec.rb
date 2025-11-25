require 'rails_helper'

RSpec.describe User, type: :model do
  # 💡 let(:user) で有効なデータを生成（テストごとに新しいインスタンスが作られる）
  let(:user) { FactoryBot.build(:user) }

  describe 'ユーザー登録のバリデーション' do
    ## 🧪 正常系のテスト
    context '登録できる場合' do
      it 'すべての要件を満たしている場合、登録できること' do
        # userインスタンスがDBに保存できる（有効である）ことを検証
        expect(user).to be_valid
      end
    end

    ## ❌ 異常系のテスト
    context '登録できない場合' do
      # ----------------------------------------------------
      # メールアドレスに関するテスト
      # ----------------------------------------------------
      it 'メールアドレスが空では登録できないこと（必須）' do
        user.email = ''
        user.valid?
        expect(user.errors.full_messages).to include('Eメールを入力してください')
      end

      it '重複したメールアドレスでは登録できないこと（一意性）' do
        # 既に有効なユーザーをDBに保存
        user.save
        # DBに保存されたユーザーと同じemailを持つインスタンスを作成
        user_duplicate = FactoryBot.build(:user, email: user.email)

        user_duplicate.valid?
        expect(user_duplicate.errors.full_messages).to include('Eメールはすでに存在します')
      end

      it 'メールアドレスに@が含まれていない場合、登録できないこと' do
        user.email = 'testuser.com'
        user.valid?
        expect(user.errors.full_messages).to include('Eメールは不正な値です')
      end

      # ----------------------------------------------------
      # パスワードに関するテスト
      # ----------------------------------------------------
      it 'パスワードが空では登録できないこと（必須）' do
        user.password = ''
        user.valid?
        expect(user.errors.full_messages).to include('パスワードを入力してください')
      end

      it 'パスワードが5文字以下では登録できないこと（6文字以上が必須）' do
        user.password = '12345'
        user.password_confirmation = '12345'
        user.valid?
        expect(user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end

      it 'パスワードと確認用の値が一致しないと登録できないこと' do
        user.password = 'password123'
        user.password_confirmation = 'password456'
        user.valid?
        expect(user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
    end
  end
end
