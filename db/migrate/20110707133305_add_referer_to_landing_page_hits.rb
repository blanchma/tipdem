# -*- encoding : utf-8 -*-
class AddRefererToLandingPageHits < ActiveRecord::Migration
  
  def self.up
    add_column :landing_page_hits, :referrer, :string
  end

  def self.down
    remove_column :landing_page_hits, :referrer
  end

end
