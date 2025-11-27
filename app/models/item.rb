class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :category
  belongs_to_active_hash :condition
  belongs_to_active_hash :shipping_fee_payer
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :shipping_day

  belongs_to :user
  belongs_to :category

  has_one_attached :image
  has_one :order

  validates :price, presence: true
  validates :category_id, presence: true

  validates :price, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 300,
    less_than_or_equal_to: 9_999_999,
    message: 'は、¥300〜¥9,999,999の範囲内の半角数値で入力してください'
  }

  validates :name, presence: true
  validates :description, presence: true
  validates :image, presence: true

  validates :category_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :condition_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :shipping_fee_payer_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :prefecture_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :shipping_day_id, numericality: { other_than: 1, message: 'を選択してください' }
end
