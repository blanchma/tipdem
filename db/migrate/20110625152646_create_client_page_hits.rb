# -*- encoding : utf-8 -*-
class CreateClientPageHits < ActiveRecord::Migration
  def self.up
    create_table :client_page_hits do |t|
      t.integer  :fisher_id
      t.string  :channel
      t.integer   :client_id
      t.integer  :campaign_id
      t.timestamps
    end
  end


  def self.down
    drop_table :client_page_hits
  end
end

