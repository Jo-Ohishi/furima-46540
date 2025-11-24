# db/seeds.rb (抜粋)

# 💡 ユーザーが存在しないと Item を作成できないため、まずユーザーを作成/取得
user = User.find_or_create_by!(email: 'test@example.com') do |u|
  u.nickname = 'ダミー出品者'
  u.password = 'password123'
  u.password_confirmation = 'password123'
end

# 💡 ダミー商品データの作成
# 注意: Active Storageの画像は、別途ファイルを配置する必要があります。
# ここではダミー画像ファイルを 'public/images/dummy.jpg' に置いたと仮定します。
if Item.count == 0 
  Item.create!(
    name: '【ダミー】未使用の最新スマホ',
    description: 'ダミーデータとして表示しています。まだ出品はありません。',
    price: 30000,
    user_id: user.id,
    
    # 💡 ID: 1 以外を適当に設定（Active Hashのバリデーションを通過させるため）
    category_id: 3,           # 例: メンズ
    condition_id: 2,          # 例: 未使用に近い
    shipping_fee_payer_id: 2,
    prefecture_id: 2,
    shipping_day_id: 2
  ) do |item|
    # Active Storageの画像を添付
    # File.open() でローカルの画像ファイルパスを指定する必要があります
    file_path = Rails.root.join('public', 'images', 'item-sample.png') 
    item.image.attach(io: File.open(file_path), filename: 'item-sample.png', content_type: 'image/jpeg')
  end
end

puts "Seed data created successfully. Total items: #{Item.count}"