# -*- encoding : utf-8 -*-
class InsertCategoriesKeys < ActiveRecord::Migration
  def self.up
        Category.create(:name => "Indumentaria")

  end

  def self.down
  end
end
