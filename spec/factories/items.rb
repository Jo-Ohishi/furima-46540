# spec/factories/items.rb

FactoryBot.define do
  factory :item do
    # ユーザーとの関連付け
    # 💡 関連付けられたユーザーもFactoryBotで自動生成する（:user ファクトリが存在すること前提）
    association :user

    # 必須項目
    name { 'テスト商品名' }
    description { '商品の説明文です。' }
    price { 5000 } # 300〜9,999,999 の範囲内の値

    # Active Hash / Enum の ID（other_than: 1 を満たすように 2 以上の値を設定）
    category_id { 2 }
    condition_id { 2 }
    shipping_fee_payer_id { 2 }
    prefecture_id { 2 }
    shipping_day_id { 2 }

    # Active Storage の画像添付
    # 💡 fixture_file_upload を使用して、ダミー画像を添付
    image { Rack::Test::UploadedFile.new(Rails.root.join('public/test_image.png'), 'image/png') }

    # ※ 注意: 画像の添付には、public/images/test_image.png が存在している必要があります。
    #          または、ダミー画像生成ライブラリ（Fakerなど）を使用してください。
  end
end
