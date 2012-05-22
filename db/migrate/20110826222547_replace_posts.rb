# -*- encoding : utf-8 -*-
class ReplacePosts < ActiveRecord::Migration
  def self.up
    drop_table :posts
    create_table :posts do |t|
      t.integer   :campaign_id
      t.integer   :user_id
      t.string    :channel
      t.string    :message
      t.string    :status
      t.boolean   :daily, :default => false
      t.integer   :hour
      t.integer   :hour_utc
      t.string    :response
      t.string    :post_id
      t.integer    :attemps, :default => 0

      t.string    :more
      t.integer   :counter, :default => 0

      t.string    :targets
      t.string    :privacy

      t.datetime  :posted_at
      t.boolean :revenued
    end
  end

  def self.down
    drop_table :posts
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
end
