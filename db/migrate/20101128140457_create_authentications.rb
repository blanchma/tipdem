# -*- encoding : utf-8 -*-
class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.integer :user_id
      t.string :uid
      t.string :provider
      t.string :token
      t.string :secret
      t.integer   :friends_count
      t.timestamps
    end
  end

  def self.down
    drop_table :authentications
  end
end
