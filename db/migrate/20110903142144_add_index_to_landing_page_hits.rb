# -*- encoding : utf-8 -*-
class AddIndexToLandingPageHits < ActiveRecord::Migration
  def self.up
    add_index :landing_page_hits, :campaign_id
  end

  def self.down
    remove_index :landing_page_hits, :campaign_id
  end
end
