# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => "categories_users"
  has_and_belongs_to_many :campaigns, :join_table => "categories_campaigns"
end
