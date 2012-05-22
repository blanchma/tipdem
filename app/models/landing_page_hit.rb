# -*- encoding : utf-8 -*-
class LandingPageHit < ActiveRecord::Base
  belongs_to :fisher, :class_name => "User", :foreign_key => "fisher_id"
  belongs_to :campaign

  BOTS = ["gnip", "bitlybot", "JS-Kit", "bot", "PostRank", "UnwindFetchor", "Bot",
    "Python", "facebookexternalhit", "Butterfly"]


 scope :facebook, :conditions => {:channel => Channel::Facebook}
 scope :twitter, :conditions => {:channel => Channel::Twitter}
 scope :default, :conditions => {:channel => Channel::Default}

  validates_presence_of :campaign, :channel, :user_agent
  validate :humanity
  validate :ip_uniqueness

  after_create :create_revenue

  def create_revenue
    if channel != Channel::Default && !fisher.nil?
      Revenue.create(:user => self.fisher, :campaign => self.campaign, :source => self)
    end
  end
  #handle_asynchronously :create_revenue#, :run_at => Proc.new { 1.minutes.from_now }

  def self.get_data_for_graph(id)
    h = Hash.new
    list = LandingPageHit.find_all_by_campaign_id id
    list.each do |click|
      time = click.created_at.to_s.split()[0]
      if not h.has_key?(time)
        h[time] = 1
      else
        h[time] += 1
      end
    end
    return h
  end

  def humanity
    if user_agent
      BOTS.each do |bot|
        if user_agent.include? bot
          errors.add(:user_agent, :invalid)
          break;
        end
      end
    end
  end

  def ip_uniqueness
    if LandingPageHit.exists?({:campaign_id => campaign_id, :ip => ip})
      errors.add(:ip => "existe para esta campaña")
    end
  end

end

