# -*- encoding : utf-8 -*-
class Chain < ActiveRecord::Base

  belongs_to :fish, :class_name => 'User', :foreign_key => 'fish_id'
  belongs_to :fisher, :class_name => 'User', :foreign_key => 'fisher_id'

  belongs_to :campaign


  scope :facebook, :conditions => {:channel => Channel::Facebook}
  scope :twitter, :conditions => {:channel => Channel::Twitter}
  scope :default, :conditions => {:channel => Channel::Default}


  validates_presence_of :fish, :fisher, :campaign, :channel

  #after_create :create_revenue

  def create_revenue
    Revenue.create(:user => self.fisher, :campaign => self.campaign, :source => self)
  end

  def self.build(click)
    return unless click
    campaign_id = click["campaign"]
    user_id = click["user"]
    channel = click["channel"]
    if user_id
      Chain.create(:campaign_id => campaign_id, :fisher_id => user_id,
      :fish_id => id, :channel => channel)
    end
  end

  #handle_asynchronously :create_revenue, :run_at => Proc.new { 1.minutes.from_now }

      #TODO mover a un callback en el model
=begin
      if Revenue.add_revenues_values(session[:fisher_id], session[:campaign_id])
        flash[:award] = "Esta en condiciones de canjear puntos por premios!!! vaya a la solapa Awards"
        DefaultMail::deliver_contact_email
      end
      @campaign.reference_type
      @revenue = Revenue.create_revenue(session[:campaign_id])
      @revenue.user_id = current_user.id
      @revenue.save
      current_user.revenues << @revenue
      current_user.save
=end


end

