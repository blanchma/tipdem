# -*- encoding : utf-8 -*-
class CampaignNotified < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign  
end
