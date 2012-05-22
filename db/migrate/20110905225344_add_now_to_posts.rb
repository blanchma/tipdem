# -*- encoding : utf-8 -*-
class AddNowToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :now, :boolean
  end

  def self.down
    remove_column :posts, :now
  end
end
