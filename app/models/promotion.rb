# -*- encoding : utf-8 -*-
class Promotion < ActiveRecord::Base
  attr_reader :posts, :chains, :revenues, :landing_page_hits, :client_page_hits
  attr_reader :per_page
  @@per_page = 5

  belongs_to :user
  belongs_to :campaign

  scope :not_owned ,lambda {
    #{:conditions => ["user_id = ? AND user_id != ?", self.user_id , self.campaign.user_id ]}
    {:include => :campaign, :conditions => ["campaigns.user_id != promotions.user_id"]}
  }

  scope :owned ,lambda {
    #{:conditions => ["user_id = ? AND user_id != ?", self.user_id , self.campaign.user_id ]}
    {:include => :campaign, :conditions => ["campaigns.user_id == promotions.user_id"]}
  }

  after_create :chain!

  def posts
    @posts ||= user.posts.published.all(:conditions=> {:campaign_id => campaign_id})
  end

  def chains
    @chains ||= user.chains.all(:conditions=> {:campaign_id => campaign_id})
  end

  def landing_page_hits
    @landing_page_hits ||= user.landing_page_hits.all(:conditions=> {:campaign_id => campaign_id})
  end

  def client_page_hits
    @client_page_hits ||= user.client_page_hits.all(:conditions=> {:campaign_id => campaign_id})
  end

  def revenues
    @revenues ||= user.revenues.all(:conditions=> {:campaign_id => campaign_id})
  end

  def chain!
    #In case user is not chained already then it's chained to the first campaign promoted by it
    unless Chain.exists?(["campaign_id = ? AND fish_id = ? ", campaign_id, user_id ]) || user_id == campaign.user_id
      Chain.create(:fisher_id => campaign.user_id, :fish_id => user_id, :campaign_id => campaign_id, :channel => Channel::Default)
    end
  end

end

