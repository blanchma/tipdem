# -*- encoding : utf-8 -*-
class AddUserAgentToLandingPageHits < ActiveRecord::Migration
  def self.up
    add_column :landing_page_hits, :user_agent, :string
  end

  def self.down
    remove_column :landing_page_hits, :user_agent
  end
end
