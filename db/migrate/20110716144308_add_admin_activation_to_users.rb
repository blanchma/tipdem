# -*- encoding : utf-8 -*-
class AddAdminActivationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :approved, :boolean, :default => false
  end

  def self.down
    remove_column :users, :approved
  end
end
