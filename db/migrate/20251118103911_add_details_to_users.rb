class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nickname, :string, null: true
    add_column :users, :email, :string, null: false
    add_column :users, :encrypted_password, :string, null: true
    add_column :users, :last_name, :string, null: true
    add_column :users, :first_name, :string, null: true
    add_column :users, :last_name_kana, :string, null: true
    add_column :users, :first_name_kana, :string, null: true
    add_column :users, :birth_date, :date, null: true
  end
end
