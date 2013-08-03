class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :email,              :null => false, :default => ''
      t.string :encrypted_password, :null => false, :default => ''

      t.datetime :remember_created_at

      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.string :password_salt
      t.string :authentication_token


      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
