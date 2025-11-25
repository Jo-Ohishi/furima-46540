user = User.find_or_create_by!(email: 'test@example.com') do |u|
  u.nickname = 'ダミー出品者'
  u.password = 'password123'
  u.password_confirmation = 'password123'
end

if Item.count == 0 
  Item.create!(
    name: '【ダミー】未使用の最新スマホ',
    description: 'ダミーデータとして表示しています。まだ出品はありません。',
    price: 30000,
    user_id: user.id,

    category_id: 3,           
    condition_id: 2,          
    shipping_fee_payer_id: 2,
    prefecture_id: 2,
    shipping_day_id: 2
  ) do |item|
    file_path = Rails.root.join('public', 'images', 'item-sample.png') 
    item.image.attach(io: File.open(file_path), filename: 'item-sample.png', content_type: 'image/jpeg')
  end
end

puts "Seed data created successfully. Total items: #{Item.count}"