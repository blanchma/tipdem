# -*- encoding : utf-8 -*-
class LandingPageHit < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign, :class_name => "Campaign::Base", :foreign_key => "campaign_id"

 scope :facebook, :conditions => {:channel => Channel::Facebook}
 scope :twitter, :conditions => {:channel => Channel::Twitter}
 scope :non_channel, where("channel IS NULL")

  validates_presence_of :campaign, :user_agent
  validate :humanity
  validates_uniqueness_of :ip, :scope => [:campaign_id, :user_id]

  after_create :create_revenue

  def create_revenue
    unless channel == Channel::Default && user.blank?
      Point.create(:user => self.user, :campaign => self.campaign, :landing_page_ => self)
    end
  end
  #handle_asynchronously :create_revenue#, :run_at => Proc.new { 1.minutes.from_now }

  def self.create_from_request(request)
    unless request.cookies.include? "click_#{request.params[:id]}"
      landing_page_hit = LandingPageHit.create(
        user_id:    request.params[:user_id],
        channel:      request.params[:channel],
        campaign_id:  request.params[:id],
        ip:           request.remote_ip,
        referrer:     request.referrer,
        user_agent:   request.user_agent || request.env["HTTP_USER_AGENT"])
    else
      return false
    end
    landing_page_hit.valid?
  end

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
    AntiSpamService.human?(self.user_agent)
  end

  def ip_uniqueness
    if LandingPageHit.exists?({:campaign_id => campaign_id, :ip => ip})
      errors.add(:ip => "existe para esta campaña")
    end
  end

end


# == Schema Information
#
# Table name: landing_page_hits
#
#  id          :integer(4)      not null, primary key
#  user_id   :integer(4)
#  channel     :string(255)
#  client_id   :integer(4)
#  campaign_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  ip          :string(255)
#  referrer    :string(255)
#  user_agent  :string(255)
#

