FactoryBot.define do
  factory :order_form do
    # user_id          { FactoryBot.create(:user).id }
    # item_id          { FactoryBot.create(:item).id }
    token            { 'tok_abcdefg1234567890' }
    city             { '東京都' }
    street_addresses { '青山1-1-1' }
    postal_code      { '123-4567' }
    prefecture_id    { 2 }
    phone_number     { '09012345678' }
    building_name    { '青山ビル' }
  end
end
