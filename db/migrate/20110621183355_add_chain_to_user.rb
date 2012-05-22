# -*- encoding : utf-8 -*-
class AddChainToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :chain_id, :integer
  end

  def self.down
    remove_column :users, :chain_id
  end
end
