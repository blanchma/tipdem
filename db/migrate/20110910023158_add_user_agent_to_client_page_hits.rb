# -*- encoding : utf-8 -*-
class AddUserAgentToClientPageHits < ActiveRecord::Migration
  def self.up
    add_column :client_page_hits, :user_agent, :string
    add_column :client_page_hits, :ip, :string
  end

  def self.down
    remove_column :client_page_hits, :ip
    remove_column :client_page_hits, :user_agent
  end
end
