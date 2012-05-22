# -*- encoding : utf-8 -*-
class AddFollowersToAuthentications < ActiveRecord::Migration
  def self.up
    add_column :authentications, :followers_count, :integer
    add_column :authentications, :following_count, :integer
  end

  def self.down
    remove_column :authentications, :followers_count
    remove_column :authentications, :following_count
  end
end
