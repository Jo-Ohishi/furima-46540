# FactoryBot.define do
#   # 💡 ActiveRecordモデルではないため、factoryの定義名に注意
#   factory :shipping_address do
#     # 配送先住所情報 (バリデーションに適合)
#     postal_code      { '123-4567' }
#     prefecture_id    { 2 } # 0または1以外の有効なIDを想定
#     city             { '東京都' }
#     street_addresses { '青山1-1-1' }
#     building_name    { '青山ビル' } # 任意項目
#     phone_number     { '09012345678' }
#   end
# end
