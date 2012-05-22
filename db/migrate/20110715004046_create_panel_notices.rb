# -*- encoding : utf-8 -*-
class CreatePanelNotices < ActiveRecord::Migration
  def self.up
    create_table :panel_notices do |t|
      t.string :message
      t.timestamps
    end
  end

  def self.down
    drop_table :panel_notices
  end
end
