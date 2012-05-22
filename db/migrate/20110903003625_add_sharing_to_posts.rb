# -*- encoding : utf-8 -*-
class AddSharingToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :retweets, :integer, :default => 0
    add_column :posts, :likes, :integer, :default => 0
    add_column :posts, :comments, :integer, :default => 0
  end

  def self.down
    remove_column :posts, :comments
    remove_column :posts, :likes
    remove_column :posts, :retweets
  end
end
