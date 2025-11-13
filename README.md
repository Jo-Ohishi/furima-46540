# テーブル設計

## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| nickname           | string | null: false |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false |
| last_name          | string | null: false |
| first_name         | string | null: false |
| last_name_kana     | string | null: false |
| first_name_kana    | string | null: false |
| birth_date         | date   | null: false |

## items テーブル

| Column              | Type    | Options     |
| ------------------- | ------- | ----------- |
| item_image          | string  | null: false |
| item_name           | string  | null: false |
| description         | text    | null: false |
| price               | integer | null: false |
| category            | string  | null: false |
| condition           | string  | null: false |
| shipping_fee_payer  | string  | null: false |
| shipping_prefecture | string  | null: false |
| shipping_days       | string  | null: false |
| seller_id           | references | null: false, foreign_key: true |


## comments テーブル

| Column       | Type       | 
Options                                |
| ------       | ------     | ------------------------------ |
| content      | text       | null: false |
| items_id     | references | null: false, foreign_key: true |
| user_id      | references | null: false, foreign_key: true |

## shipping_addresses　テーブル

| Column              | Type    | Options     |
| ------------------- | ------- | ----------- |
| postal_code         | string  | null: false |
| prefecture          | string  | null: false |
| city                | string  | null: false |
| street_address      | string  | null: false |
| building_name       | string  | null: false |
| phone_number        | string  | null: false |
| purchases_id        | references | null: false, foreign_key: true |



## 　purchases テーブル

| Column              | Type       | Options     |
| ------------------- | -------    | ----------- |
| items_id            | references | null: false, foreign_key: true |
| buyer_id            | references | null: false, foreign_key: true |
| shipping_address_id | references | null: false, foreign_key: true |

