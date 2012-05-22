# -*- encoding : utf-8 -*-
class ReplacePictureUrlForMainImageUrl < ActiveRecord::Migration
  def self.up
    remove_column :landing_pages, :picture_url
    add_column :landing_pages, :main_image_url, :string
    remove_column :landing_pages, :main_image_is_logo
    add_column :landing_pages, :main_image_source, :string
  end

  def self.down
    add_column :landing_pages, :picture_url, :string
    remove_column :landing_pages, :main_image_url
    add_column :landing_pages, :main_image_is_logo, :boolean
    remove_column :landing_pages, :main_image_source
  end
end
