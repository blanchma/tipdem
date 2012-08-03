# -*- encoding : utf-8 -*-
class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer   :user_id
      t.string    :uid
      t.string    :provider
      t.string    :token
      t.string    :secret
      t.string    :login
      t.string    :name
      t.integer   :friends_count
      t.text      :auth_hash
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
