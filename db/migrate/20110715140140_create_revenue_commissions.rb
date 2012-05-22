# -*- encoding : utf-8 -*-
class CreateRevenueCommissions < ActiveRecord::Migration
  def self.up
    create_table :revenue_commissions do |t|
      t.integer   :revenue_id
      t.integer   :campaign_id
      t.decimal   :money, :precision => 8, :scale => 2 , :default => 0.00
      t.string    :source_class
      t.integer   :source_id
      t.timestamps
    end
  end

  def self.down
    drop_table :revenue_commissions
  end
end
