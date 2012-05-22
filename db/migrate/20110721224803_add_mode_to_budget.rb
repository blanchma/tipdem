# -*- encoding : utf-8 -*-
class AddModeToBudget < ActiveRecord::Migration
  def self.up

    add_column :budgets, :mode, :string

    Campaign.all.each do |camp|
      if camp.budget
        budget = camp.budget
        budget.mode = camp.mode
        budget.save
      end
    end

    remove_column :campaigns, :mode

  end

  def self.down
    add_column :campaigns, :mode, :string

      Budget.all.each do |budget|
      if budget.campaign
        campaign = budget.campaign
        campaign.mode = budget.mode
        campaign.save
      end
    end

    remove_column :budgets, :mode
  end
end
