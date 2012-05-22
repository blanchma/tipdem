# -*- encoding : utf-8 -*-
class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.integer :campaign_id
      t.decimal :pay_per_lead, :precision => 8, :scale => 2,:default => 0.00
      t.decimal :pay_per_facebook_contact, :precision => 8, :scale => 2, :default => 0.00
      t.decimal :pay_per_twitter_contact, :precision => 8, :scale => 2, :default => 0.00
      t.decimal :pay_per_landing_page_hit, :precision => 8, :scale => 2,:default => 0.00
      t.decimal :pay_per_client_page_hit, :precision => 8, :scale => 2,:default => 0.00
      t.decimal :spent, :precision => 8, :scale => 2, :default => 0.00
      t.decimal :total, :precision => 8, :scale => 2,:default => 0.00
      t.decimal :cost, :precision => 8, :scale => 2,:default => 0.00
      t.timestamps
    end
  end

  def self.down
    drop_table :budgets
  end
end
