# -*- encoding : utf-8 -*-
class CreateLandingPageHits < ActiveRecord::Migration
  def self.up
    create_table :landing_page_hits do |t|
      t.integer   :user_id
      t.string    :channel
      t.integer   :campaign_id
      t.string    :referrer
      t.string    :ip
      t.string    :user_agent
      t.timestamps
    end
  end

  def self.down
    drop_table :landing_page_hits
  end
end

