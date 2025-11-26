require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  describe 'ユーザー登録のバリデーション' do
    context '登録できる場合' do
      it 'すべての要件を満たしている場合、登録できること' do
        expect(user).to be_valid
      end
    end

    context '登録できない場合' do
      it 'メールアドレスが空では登録できないこと（必須）' do
        user.email = ''
        user.valid?
        expect(user.errors.full_messages).to include('Email can\'t be blank')
      end

      it 'ニックネームが空では登録できないこと' do
        user.nickname = ''
        user.valid?
        expect(user.errors.full_messages).to include('Nickname can\'t be blank')
      end

      it '生年月日が空では登録できないこと' do
        user.birth_date = nil
        user.valid?
        expect(user.errors.full_messages).to include('Birth date can\'t be blank')
      end

      it '重複したメールアドレスでは登録できないこと（一意性）' do
        user.save
        user_duplicate = FactoryBot.build(:user, email: user.email)
        user_duplicate.valid?
        expect(user_duplicate.errors.full_messages).to include('Email has already been taken')
      end

      it '氏名（姓）が空では登録できないこと' do
        user.last_name = ''
        user.valid?
        expect(user.errors.full_messages).to include('Last name can\'t be blank')
      end

      it '氏名（名）が全角以外（例: 半角英字）では登録できないこと' do
        user.first_name = 'taro'
        user.valid?
        expect(user.errors.full_messages).to include('First name is invalid')
      end

      it '氏名（姓カナ）が全角カタカナ以外（例: ひらがな）では登録できないこと' do
        user.last_name_kana = 'やまだ'
        user.valid?
        expect(user.errors.full_messages).to include('Last name kana は全角カタカナで入力してください')
      end

      it 'メールアドレスに@が含まれていない場合、登録できないこと' do
        user.email = 'testuser.nodomaincom'
        user.valid?
        expect(user.errors.full_messages).to include('Email is invalid')
      end

      it '氏名（名カナ）が全角カタカナ以外（例: 半角カナ）では登録できないこと' do
        user.first_name_kana = 'ﾀﾛｳ'
        user.valid?
        expect(user.errors.full_messages).to include('First name kana は全角カタカナで入力してください')
      end

      it 'パスワードが空では登録できないこと（必須）' do
        user.password = ''
        user.valid?
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

      it 'パスワードが数字を含まない（英字のみ）では登録できないこと' do
        user.password = 'abcdefgh'
        user.password_confirmation = 'abcdefgh'
        user.valid?
        expect(user.errors.full_messages).to include('Password は英字と数字を両方含む必要があります')
      end

      it 'パスワードが英字を含まない（数字のみ）では登録できないこと' do
        user.password = '12345678'
        user.password_confirmation = '12345678'
        user.valid?
        expect(user.errors.full_messages).to include('Password は英字と数字を両方含む必要があります')
      end

      it '名（全角）が空だと登録できない' do
        user.first_name = ''
        user.valid?
        expect(user.errors.full_messages).to include('First name can\'t be blank')
      end

      it '名（カナ）が空だと登録できない' do
        user.first_name_kana = ''
        user.valid?
        expect(user.errors.full_messages).to include('First name kana can\'t be blank')
      end

      it '姓（カナ）が空だと登録できない' do
        user.last_name_kana = ''
        user.valid?
        expect(user.errors.full_messages).to include('Last name kana can\'t be blank')
      end

      it '全角文字を含むパスワードでは登録できない' do
        user.password = 'ｐａｓｓｗｏｒｄ'
        user.password_confirmation = 'ｐａｓｓｗｏｒｄ'
        user.valid?
        expect(user.errors.full_messages).to include('Password は英字と数字を両方含む必要があります')
      end
    end
  end
end
