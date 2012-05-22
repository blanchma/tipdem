# -*- encoding : utf-8 -*-
class AddEmailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_recommendations, :boolean, :default => true
    add_column :users, :recommended_campaign_ids, :string
    add_column :users, :email_newsletter, :boolean, :default => true

    User.all.each do |user|
      user.recommended_campaign_ids = []
      user.save
    end
  end

  def self.down
    remove_column :users, :email_newsletter
    remove_column :users, :email_recommendations
    remove_column :users, :recommended_campaign_ids
  end
end
