# -*- encoding : utf-8 -*-
class AddIndexToChains < ActiveRecord::Migration
  def self.up
      add_index :chains, :fisher_id
      add_index :chains, :fish_id

      add_index :landing_page_hits, :fisher_id
  end

  def self.down
    remove_index :chains, :fisher_id
    remove_index :chains, :fish_id
    remove_index :landing_page_hits, :fisher_id
  end
end
