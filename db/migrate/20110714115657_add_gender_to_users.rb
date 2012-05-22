# -*- encoding : utf-8 -*-
class AddGenderToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :gender, :string
  end

  def self.down
    remove_column :users, :gender
  end
end
