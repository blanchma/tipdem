# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :time_zone,
  :gender, :approved, :remember_me, :locale
  attr_accessor :captcha, :random_password

  delegate :followers_count, :following_count, :to => :twitter_account, :allow_nil => true
  delegate :friends_count, :to => :facebook_account, :allow_nil => true

  scope :verified, :conditions => "confirmed_at IS NOT NULL"
  scope :email_with_recommendations, :conditions => {:email_recommendations => true}

  has_one :facebook_account
  has_one :twitter_account
  has_one :linked_in_account
  has_one :dinero_mail_account
  has_one  :chain, :foreign_key => "fish_id"

  has_many :revenues
  has_many :owned_campaigns, :class_name => "Campaign", :dependent => :destroy
  has_many :promotions
  has_many :promoted_campaigns, :through => :promotions, :source => :campaign

  has_many :posts, :dependent => :destroy
  has_many :landing_page_hits, :foreign_key => "fisher_id"
  has_many :client_page_hits , :foreign_key => "fisher_id"
  has_many :chains, :foreign_key => "fisher_id"
  has_many :authentications, :dependent => :destroy
  has_many :payment_requests
  has_many :payments

  has_and_belongs_to_many :categories, :join_table => "categories_users"

  serialize :recommended_campaign_ids, Array

  validates_presence_of :captcha, :message => :invalid, :on => :create, :if => "authentications.empty?"

  before_create :set_random_password, :default_values
  after_create :welcome

  def password_required?
    ((authentications.empty?) || !password.blank?)  && super
  end

  def validate_captcha
      errors.add(:captcha, :invalid) if authentications.empty? || self.captcha != true
  end

  def approve!
    self.approved = true
    ContactMailer.delay.deliver_approved_email(self)# unless Rails.env === 'development' || Rails.env === 'test'
  end

  def chained?
    !self.chain.nil?
  end

  def active?
    true
  end

  def chain!(click)
    return unless click
    campaign_id = click["campaign"]
    user_id = click["user"]
    channel = click["channel"]
    #cookies["click"].

    return if user_id.nil?

    chain = Chain.create(:campaign_id => campaign_id, :fisher_id => user_id,
      :fish_id => id, :channel => channel)
    self.chain=chain if chain.valid?

  end

  def self.credentials_to_omniauth(credential,session)
    {:provider => Channel::Twitter, :uid => credential.id, :token => session[:twitter_token],
      :secret => session[:twitter_secret], :name => credential.name || credential.screen_name,
      :followers_count => credential.followers_count, :following_count => credential.friends_count
    }
  end

  def apply_omniauth (omniauth)
    self.username = omniauth["info"]["name"] if self.username.blank?

    self.gender= omniauth["info"]["gender"] unless self.gender
    self.birthday= omniauth["info"]["birthday"]

    omniauth_email = omniauth["info"]["email"]
    if (self.email.nil? || self.email.blank?) &&  omniauth_email && !omniauth_email.include?("proxymail.facebook")
      self.email = omniauth["info"]["email"]
    elsif self.email.nil? || self.email.blank?
      self.email = "#{Devise.friendly_token}@please-replace.com"
    end

    return self.authentications.build(:user_id => id, :provider => omniauth["provider"], :uid => omniauth["uid"],
        :token => omniauth["credentials"]["token"], :secret => omniauth["credentials"]["secret"])
  end

  def fake_email?
    self.email && self.email.include?("please-replace.com")
  end

  #not yet implemented
  def set_random_password
    if encrypted_password.nil? || encrypted_password.blank?
      pwd = Devise.friendly_token
      @random_password = pwd
      self.password = pwd
      self.password_confirmation = pwd
    end
  end

  def twitter?
    !twitter_account.nil?
  end

  def facebook?
    !facebook_account.nil?
  end

  def linked_in?
    !linked_in_account.nil?
  end


  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if
      params[:password_confirmation].blank?
    end
    update_attributes(params)
  end

 def only_if_unconfirmed
    unless_confirmed {yield}
  end


  def welcome
    #UserMailer.delay.deliver_welcome_email(self) unless fake_email?
    self.send_confirmation_instructions unless fake_email?
    #Delayed::Job.enqueue(CountFriendsJob.new(self)) unless authentications.empty?
  end

  private
  def default_values
    self.recommended_campaign_ids = []
  end

end

