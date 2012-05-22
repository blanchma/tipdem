# -*- encoding : utf-8 -*-
class ChangeBodyFromLandingPages < ActiveRecord::Migration
  def self.up
    change_column(:landing_pages, :body, :text)
  end

  def self.down
    change_column(:landing_pages, :body, :string)
  end
end
