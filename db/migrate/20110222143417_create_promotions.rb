# -*- encoding : utf-8 -*-
class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.integer :campaign_id
      t.integer :user_id
      t.integer :landing_page_hits, :default => 0
      t.integer :fb_posts, :default => 0
      t.integer :fb_comments, :default => 0
      t.integer :fb_likes, :default => 0
      t.integer :tw_posts, :default => 0
      t.integer :tw_retweets, :default => 0
      t.integer :count_chains, :default => 0
      t.decimal :current_money, :precision => 8, :scale => 2 , :default => 0.00
      t.integer :current_points, :default => 0
      t.timestamps
    end
    
  end

  def self.down
    drop_table :promotions
  end
end
