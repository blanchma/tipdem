# -*- encoding : utf-8 -*-
class CreateFacebookPages < ActiveRecord::Migration
  def self.up
     create_table :facebook_pages do |t|
      t.integer   :user_id
      t.integer   :authentication_id
      t.string    :page_id
     end
  end

  def self.down
    drop_table :facebook_pages
  end
end
