# -*- encoding : utf-8 -*-
class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer   :campaign_id
      t.integer   :user_id
      t.string    :channel
      t.string    :message
      t.boolean   :now
      t.string    :status
      t.boolean   :daily, :default => false
      t.integer   :hour
      t.integer   :hour_utc
      t.string    :response
      t.string    :post_id
      t.integer   :attemps, :default => 0
      t.string    :more
      t.integer   :counter, :default => 0
      t.datetime  :when_post
      t.datetime  :posted_at
      t.boolean   :removed
    end

    add_index :posts, :hour_utc
    add_index :posts, :when_post
    add_index :posts, :posted_at
    add_index :posts, [:user_id, :campaign_id]
  end

  def self.down
    drop_table :posts
  end

end
