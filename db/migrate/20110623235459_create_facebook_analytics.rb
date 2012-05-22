# -*- encoding : utf-8 -*-
class CreateFacebookAnalytics < ActiveRecord::Migration
  def self.up
    create_table :facebook_analytics do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_analytics
  end
end
