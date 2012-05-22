# -*- encoding : utf-8 -*-
class CreateFacebookGroups < ActiveRecord::Migration
  def self.up
     create_table :facebook_groups do |t|
      t.integer   :user_id
      t.integer   :authentication_id
      t.string    :group_id
     end
  end

  def self.down
    drop_table :facebook_groups
  end

end
