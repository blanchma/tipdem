# -*- encoding : utf-8 -*-
class CreatePosts < ActiveRecord::Migration
  def self.up
     create_table :posts do |t|
      t.integer :post_form_id
      t.integer :user_id
      t.integer :campaign_id      
      t.string :status
      t.string :message
      t.string :channel      
      t.string :response
      t.string  :post_id
      t.string :stats
      t.datetime :posted_at
      t.boolean :revenued_facebook,  :default => false
      t.boolean :revenued_twitter,  :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
