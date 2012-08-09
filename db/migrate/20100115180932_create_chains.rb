# -*- encoding : utf-8 -*-
class CreateChains < ActiveRecord::Migration
  def self.up
    create_table :chains do |t|
      t.integer :fisher_id
      t.integer :fish_id
      t.integer :campaign_id
      t.integer :baits, :default => 5
      t.string  :channel
      t.timestamps
    end
    add_index :chains, :fisher_id
    add_index :chains, :fish_id
  end

  def self.down
    remove_index :chains, :fisher_id
    remove_index :chains, :fish_id
    drop_table :chains
  end
end
