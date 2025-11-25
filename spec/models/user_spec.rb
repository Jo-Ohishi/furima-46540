require 'rails_helper'

RSpec.describe User, type: :model do
  # (FactoryBotで定義された :user ファクトリが必要です)
  let(:user) { FactoryBot.build(:user) }

  describe 'ユーザー登録のバリデーション' do
    ## 🧪 正常系のテスト
    context '登録できる場合' do
      it 'すべての要件を満たしている場合、登録できること' do
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
        # 💡 修正1: エラーメッセージを追加し、expectを完了
        expect(user.errors.full_messages).to include('Email can\'t be blank')
      end # 💡 修正1: it ブロックを閉じます

      it '重複したメールアドレスでは登録できないこと（一意性）' do
        # 既に有効なユーザーをDBに保存
        user.save
        # DBに保存されたユーザーと同じemailを持つインスタンスを作成
        user_duplicate = FactoryBot.build(:user, email: user.email)
        user_duplicate.valid?
        expect(user_duplicate.errors.full_messages).to include('Email has already been taken')
      end

      it 'メールアドレスに@が含まれていない場合、登録できないこと' do
        user.email = 'testuser.nodomaincom' # @を含まない値
        user.valid?
        expect(user.errors.full_messages).to include('Email is invalid')
      end

      # ----------------------------------------------------
      # パスワードに関するテスト
      # ----------------------------------------------------
      it 'パスワードが空では登録できないこと（必須）' do
        user.password = ''
        user.valid?
        # 💡 修正2: 複数のメッセージをカンマ区切りで渡す
        expect(user.errors.full_messages).to include('Password can\'t be blank', 'Password confirmation doesn\'t match Password')
      end

      it 'パスワードが5文字以下では登録できないこと（6文字以上が必須）' do
        user.password = '12345'
        user.password_confirmation = '12345'
        user.valid?
        expect(user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end

      it 'パスワードとパスワード（確認）の値が一致しないと登録できないこと' do
        user.password = 'password123'
        user.password_confirmation = 'password456' # 異なる値
        user.valid?
        expect(user.errors.full_messages).to include('Password confirmation doesn\'t match Password')
      end
    end
  end
end
