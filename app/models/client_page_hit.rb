# -*- encoding : utf-8 -*-
class ClientPageHit < ActiveRecord::Base
  belongs_to :fisher, :class_name => "User", :foreign_key => "fisher_id"
  belongs_to :campaign

  scope :facebook, :conditions => {:channel => Channel::Facebook}
  scope :twitter, :conditions => {:channel => Channel::Twitter}
  scope :default, :conditions => {:channel => Channel::Default}

  BOTS = ["gnip", "bitlybot", "JS-Kit", "bot", "PostRank", "UnwindFetchor", "Bot",
    "Python", "facebookexternalhit", "Butterfly"]

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
    list = ClientPageHit.find_all_by_campaign_id id
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
          errors.add(:base, "Es un robot")
          break;
        end
      end
    end

  end

  def ip_uniqueness
    if ClientPageHit.exists?({:campaign_id => campaign_id, :ip => ip})
      errors.add(:ip => "existe para esta campaña")
    end
  end


end


# == Schema Information
#
# Table name: client_page_hits
#
#  id          :integer(4)      not null, primary key
#  fisher_id   :integer(4)
#  channel     :string(255)
#  client_id   :integer(4)
#  campaign_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  url         :string(255)
#  user_agent  :string(255)
#  ip          :string(255)
#

