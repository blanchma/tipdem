# -*- encoding : utf-8 -*-
class AddUrlToClientPageHit < ActiveRecord::Migration
  def self.up
    add_column :client_page_hits, :url, :string
  end

  def self.down
    remove_column :client_page_hits, :url
  end
end
