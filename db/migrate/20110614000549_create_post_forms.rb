# -*- encoding : utf-8 -*-
class CreatePostForms < ActiveRecord::Migration
  def self.up
    create_table :post_forms do |t|
      t.integer   :campaign_id
      t.integer   :user_id
      t.string    :message
      
      t.boolean   :facebook, :default => false
      t.datetime  :last_fb_post_at
      
      t.boolean   :twitter, :default => false
      t.datetime  :last_tw_post_at
      
      t.boolean   :publish_daily
      t.integer   :hour
      t.integer   :hour_utc
    end
  end

  def self.down
    drop_table :post_forms
  end
end
