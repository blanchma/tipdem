# -*- encoding : utf-8 -*-
class CreateChains < ActiveRecord::Migration
  def self.up
    create_table :chains do |t|
      t.integer :fisher_id
      t.integer :fish_id
      t.integer :campaign_id
      t.integer :baits, :default => 5
      t.string :channel
      t.timestamps

    end
  end

  def self.down
    drop_table :chains
  end
end
