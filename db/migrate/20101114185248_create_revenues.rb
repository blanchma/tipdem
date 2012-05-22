# -*- encoding : utf-8 -*-
class CreateRevenues < ActiveRecord::Migration
  def self.up
   create_table :revenues do |t|      
      t.integer :campaign_id
      t.integer :user_id
      t.string  :mode
      t.decimal :money, :precision => 8, :scale => 2 , :default => 0.00
      t.integer :points, :default => 0

      #Revenue
      t.string :source_class
      t.integer :source_id

      t.timestamps
    end
  end

  def self.down
    drop_table :revenues
  end
end
