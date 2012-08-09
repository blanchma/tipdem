class Point < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign, :class_name => "Campaign::Base", :foreign_key => "campaign_id"
  belongs_to :landing_page_hit

  after_create :increase_points

  def increase_points
    promotion = user.find_or_create_promotion(:campaign => self.campaign)
    promotion.increase_points
    promotion.save
  end

end