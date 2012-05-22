# -*- encoding : utf-8 -*-
class ChangeModeCampaign < ActiveRecord::Migration
  def self.up
    
    add_column :campaigns, :temp_mode, :integer unless Campaign.instance_methods.include?"temp_mode"
    Campaign.all.each do |camp|
      camp.temp_mode = camp.mode      
      camp.save
    end
    
    change_column :campaigns, :mode, :string
    Campaign.all.each do |camp|
      camp.mode = (camp.temp_mode == 1 ? CampaignMode::PayPerClick : nil)
      camp.mode = (camp.temp_mode == 2 ? CampaignMode::PayPerHit : nil)
      camp.save
    end
    remove_column :campaigns, :temp_mode
  end

  def self.down
    change_column :campaigns, :mode, :integer    
  end
end
