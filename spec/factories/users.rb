FactoryBot.define do
  factory :user do
    # 💡 Deviseの必須項目
    nickname              { Faker::Name.last_name }
    email                 { |n| "test#{n}@example.com" }
    # パスワードは6文字以上、英数字混合の要件を満たすよう設定
    password              { 'a1' + Faker::Internet.password(min_length: 6) }
    password_confirmation { password }

    # 💡 ユーザーモデルに追加した他の必須項目（例として）
    last_name             { '山田' }
    first_name            { '太郎' }
    last_name_kana        { 'ヤマダ' }
    first_name_kana       { 'タロウ' }
    birth_date            { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
