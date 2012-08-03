# -*- encoding : utf-8 -*-
class CreatePosts < ActiveRecord::Migration
  def self.up
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
      t.datetime  :when_post

      t.datetime  :posted_at
      t.boolean   :removed
    end
  end

  def self.down
    drop_table :posts
  end

end
