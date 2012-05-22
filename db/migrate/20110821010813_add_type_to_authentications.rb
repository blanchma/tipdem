# -*- encoding : utf-8 -*-
class AddTypeToAuthentications < ActiveRecord::Migration
  def self.up
    add_column :authentications, :type, :string
  end

  def self.down
    remove_column :authentications, :type
  end
end
