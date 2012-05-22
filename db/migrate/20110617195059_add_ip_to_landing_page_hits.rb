# -*- encoding : utf-8 -*-
class AddIpToLandingPageHits < ActiveRecord::Migration
  def self.up
    add_column :landing_page_hits, :ip, :string
  end

  def self.down
    remove_column :landing_page_hits, :ip
  end
end
