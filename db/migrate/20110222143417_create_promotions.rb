# -*- encoding : utf-8 -*-
class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.integer :campaign_id
      t.integer :user_id
      t.integer :current_points, :default => 0
      t.timestamps
    end

    add_index :promotions, [:user_id, :campaign_id]
  end

  def self.down
    drop_table :promotions
  end
end
