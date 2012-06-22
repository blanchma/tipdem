class CreateCampaignNotified < ActiveRecord::Migration
  def up
    create_table :campaigns_notifieds, :id => false do |t|
        t.integer :user_id
        t.integer :campaign_id
    end
  end

  def down
    drop_table :campaigns_notifieds
  end
end
