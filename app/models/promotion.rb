# -*- encoding : utf-8 -*-
class Promotion < ActiveRecord::Base
  attr_reader :posts, :chains, :total_points, :total_clicks

  belongs_to :user
  belongs_to :campaign, :class_name => "Campaign::Base"

  has_many   :points
  has_many   :landing_page_hits, :through => :points

  scope :not_owned ,lambda {
    #{:conditions => ["user_id = ? AND user_id != ?", self.user_id , self.campaign.user_id ]}
    {:include => :campaign, :conditions => ["campaigns.user_id != promotions.user_id"]}
  }

  scope :owned ,lambda {
    #{:conditions => ["user_id = ? AND user_id != ?", self.user_id , self.campaign.user_id ]}
    {:include => :campaign, :conditions => ["campaigns.user_id == promotions.user_id"]}
  }

  def posts
    @posts ||= user.posts.published.where({:campaign_id => campaign_id})
  end

  def total_posts
    @chains ||= self.posts.count
  end

  def chains
    @chains ||= user.chains.where({:campaign_id => campaign_id})
  end

  def total_chains
    @chains ||= self.chains.count
  end

  def total_points
    @total_points ||= self.points.count
  end

  def total_clicks
    @landing_page_clicks ||= landing_page_hits.count
  end

  def increase_points(by=1)
    self.increment!(:current_points,by)
  end

  def claim_reward(reward)
    reward.with_lock do
      if reward.points > self.current_points && reward.current_stock > 0
        self.current_points =- reward.points
        reward.decrease(:current_stock)
        reward.save
      else
        false
      end
    end
  end

end


# == Schema Information
#
# Table name: promotions
#
#  id                :integer(4)      not null, primary key
#  campaign_id       :integer(4)
#  user_id           :integer(4)
#  landing_page_hits :integer(4)      default(0)
#  fb_posts          :integer(4)      default(0)
#  fb_comments       :integer(4)      default(0)
#  fb_likes          :integer(4)      default(0)
#  tw_posts          :integer(4)      default(0)
#  tw_retweets       :integer(4)      default(0)
#  count_chains      :integer(4)      default(0)
#  current_money     :decimal(8, 2)   default(0.0)
#  current_points    :integer(4)      default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

