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

| Column                 | Type    | Options     |
| ---------------------- | ------- | ----------- |
| item_name              | string  | null: false |
| description            | text    | null: false |
| price_id               | integer | null: false |
| category_id            | integer | null: false |
| condition_id           | integer | null: false |
| shipping_fee_payer_id  | integer | null: false |
| shipping_prefecture_id | integer | null: false |
| shipping_days_id       | integer | null: false |
| user                   | references | null: false, foreign_key: true |



## shipping_addresses　テーブル

| Column              | Type       | Options     |
| ------------------- | ---------- | ----------- |
| postal_code         | string     | null: false |
| prefecture_id       | integer    | null: false |
| city                | string     | null: false |
| street_address      | string     | null: false |
| building_name       | string     | null: false |
| phone_number        | string     | null: false |
| purchases           | references | null: false, foreign_key: true |



## 　purchases テーブル

| Column              | Type       | Options     |
| ------------------- | -------    | ----------- |
| items               | references | null: false, foreign_key: true |
| user                | references | null: false, foreign_key: true |

