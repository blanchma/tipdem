# -*- encoding : utf-8 -*-
class CreateLandingPages < ActiveRecord::Migration
  def self.up
    create_table :landing_pages do |t|      
      t.integer :campaign_id
      t.integer :template_id
      t.string :title
      t.string  :sub_title
      t.string :body
      t.string :picture_url
      t.string :main_image_file_name
      t.string :main_image_content_type
      t.integer :main_image_file_size
      t.boolean :main_image_is_logo
      t.string :owner_url
      t.timestamps
    end
  end



  def self.down
    drop_table :landing_pages
  end
end
