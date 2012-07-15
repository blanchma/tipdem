require 'factory_girl'

campaign = FactoryGirl.create(:campaign)
campaign.approve!
campaign.owner = User.first
campaign.save


campaign = FactoryGirl.create(:campaign)
campaign.approve!
campaign.owner = User.first
campaign.save