# -*- encoding : utf-8 -*-
class AddWhenToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :when_post, :datetime
    add_column :posts, :type, :string
  end

  def self.down
    remove_column :posts, :when_post
    remove_column :posts, :type
  end
end
