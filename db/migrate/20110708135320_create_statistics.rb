# -*- encoding : utf-8 -*-
class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.string   :landingPagePath
      t.string   :source
      t.string   :city
      t.datetime :date
      t.integer  :visits
      t.integer  :pageviews
      t.integer  :uniquepageviews
      t.timestamps
    end
  end

  def self.down
    drop_table :statistics
  end
end
