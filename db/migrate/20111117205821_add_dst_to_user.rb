# -*- encoding : utf-8 -*-
class AddDstToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :dst, :boolean
  end

  def self.down
    remove_column :users, :dst
  end
end
