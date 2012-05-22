# -*- encoding : utf-8 -*-
class AddCommissionsToBudgets < ActiveRecord::Migration
  def self.up
    add_column :budgets, :commission_landing_page_hit, :integer
    add_column :budgets, :commission_client_page_hit, :integer

    Budget.all.each do |budget|
      budget.commission_landing_page_hit = Commission::LandingPageHit
      budget.commission_client_page_hit = Commission::ClientPageHit
      budget.save
    end

  end

  def self.down
    remove_column :budgets, :commission_landing_page_hit
    remove_column :budgets, :commission_client_page_hit
  end
end
