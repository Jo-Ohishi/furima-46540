class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 必須項目のバリデーション
  with_options presence: true do
    validates :nickname
    validates :birth_date

    # 氏名（漢字）のバリデーション
    with_options format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/ } do
      validates :last_name
      validates :first_name
    end

    # 氏名（カナ）のバリデーション
    with_options format: { with: /\A[ァ-ヶー]+\z/, message: 'は全角カタカナで入力してください' } do
      validates :last_name_kana
      validates :first_name_kana
    end
  end

  # パスワードのバリデーション (Deviseのデフォルトに加え、任意でカスタムルールを追加)
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: 'は英字と数字を両方含む必要があります' }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
