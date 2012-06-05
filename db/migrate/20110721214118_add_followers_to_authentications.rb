# -*- encoding : utf-8 -*-
class AddFollowersToAuthentications < ActiveRecord::Migration
  def self.up
    add_column :accounts, :followers_count, :integer
    add_column :accounts, :following_count, :integer
  end

  def self.down
    remove_column :accounts, :followers_count
    remove_column :accounts, :following_count
  end
end
