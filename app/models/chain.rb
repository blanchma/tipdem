# -*- encoding : utf-8 -*-
class Chain < ActiveRecord::Base

  belongs_to :fish, :class_name => 'User', :foreign_key => 'fish_id'
  belongs_to :fisher, :class_name => 'User', :foreign_key => 'fisher_id'
  belongs_to :campaign, :class_name => 'Campaign::Base'

  scope :facebook, :conditions => {:channel => Channel::Facebook}
  scope :twitter, :conditions => {:channel => Channel::Twitter}
  scope :default, :conditions => {:channel => Channel::Default}

  validates_presence_of :fish, :fisher, :campaign, :channel

  def create_revenue
    Revenue.create(:user => self.fisher, :campaign => self.campaign, :source => self)
  end

  def self.from_session(user,click)
    begin
      chain = user.chains.create  do
        campaign_id = click["campaign_id"]
        fisher_id = click["user_id"]
        channel = click["channel"]
      end
    rescue Exception => e
      logger.info "#{e.class}: #{e.message}. click=#{click}"
      chain = false
    end
    chain
  end

end


# == Schema Information
#
# Table name: chains
#
#  id          :integer(4)      not null, primary key
#  fisher_id   :integer(4)
#  fish_id     :integer(4)
#  campaign_id :integer(4)
#  baits       :integer(4)      default(5)
#  channel     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

