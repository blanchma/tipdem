# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :time_zone,
  :gender, :approved, :remember_me, :locale

  attr_accessor :captcha, :random_password

  delegate :followers_count, :following_count, :to => :twitter_account, :allow_nil => true
  delegate :friends_count, :to => :facebook_account, :allow_nil => true

  scope    :verified, :conditions => "confirmed_at IS NOT NULL"
  scope    :email_with_recommendations, :conditions => {:email_recommendations => true}

  has_one  :facebook, :class_name => "Account::Facebook"
  has_one  :twitter, :class_name => "Account::Twitter"
  has_one  :linked_in, :class_name => "Account::LinkedIn"
  has_one  :chain, :foreign_key => "fish_id"

  has_many :revenues
  has_many :owned_campaigns, :class_name => "Campaign::Base", :dependent => :destroy
  has_many :promotions
  has_many :promoted_campaigns, :through => :promotions, :source => :campaign

  has_many :posts, :dependent => :destroy
  has_many :landing_page_hits, :foreign_key => "fisher_id"
  has_many :client_page_hits , :foreign_key => "fisher_id"
  has_many :chains, :foreign_key => "fisher_id"
  has_many :accounts, :dependent => :destroy, :class_name => "Account::Base"

  has_and_belongs_to_many :categories, :join_table => "categories_users"

  serialize :recommended_campaign_ids, Array

  validates_presence_of :captcha, :message => :invalid, :on => :create, :if => "accounts.empty?"

  before_create :gen_random_password, :default_values
  after_create :welcome

  def password_required?
    ((accounts.empty?) || !password.blank?)  && super
  end

  def validate_captcha
      errors.add(:captcha, :invalid) if accounts.empty? || self.captcha != true
  end

  def approve!
    self.approved = true
    ContactMailer.deliver_approved_email(self)# unless Rails.env === 'development' || Rails.env === 'test'
  end

  def chained?
    !self.chain.nil?
  end

  def active?
    true
  end

  def assign_user_info (auth_hash)
    self.username = auth_hash["info"]["name"] if username.blank?
    self.gender= auth_hash["info"]["gender"] if self.gender.blank?
    self.birthday= auth_hash["info"]["birthday"] if self.birthday.blank?
    if self.email.blank?
      if auth_hash["info"]["email"] && !auth_hash["info"]["email"].include?("proxymail.facebook")
        self.email = auth_hash["info"]["email"]
      else
        gen_fake_email
      end
    end
  end

  def fake_email?
    self.email && self.email.include?("@please-replace.com")
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
    #UserMailer.deliver_welcome_email(self) unless ?
    #self.send_confirmation_instructions if fake_email?
    #Delayed::Job.enqueue(CountFriendsJob.new(self)) unless accounts.empty?
  end

  private

  #Incredible magical fake email by Tute
  def gen_fake_email
    self.email = "#{self.username}#{Time.now.to_i}#{Devise.friendly_token[0...2]}@please-replace.com"
  end

  def gen_random_password(force=false)
    if force || encrypted_password.blank?
      pwd = Devise.friendly_token
      self.password = pwd
      self.password_confirmation = pwd
    end
  end

  def default_values
    #self.recommended_campaign_ids = []
  end

end


# == Schema Information
#
# Table name: users
#
#  id                       :integer(4)      not null, primary key
#  email                    :string(255)     default(""), not null
#  encrypted_password       :string(255)     default(""), not null
#  username                 :string(255)
#  locale                   :string(255)
#  chained                  :boolean(1)
#  time_zone                :string(255)
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer(4)      default(0)
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  confirmation_token       :string(255)
#  confirmed_at             :datetime
#  confirmation_sent_at     :datetime
#  authentication_token     :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  cached_slug              :string(255)
#  chain_id                 :integer(4)
#  gender                   :string(255)
#  birthday                 :date
#  admin                    :boolean(1)
#  approved                 :boolean(1)      default(FALSE)
#  email_recommendations    :boolean(1)      default(TRUE)
#  recommended_campaign_ids :string(255)
#  email_newsletter         :boolean(1)      default(TRUE)
#  dst                      :boolean(1)
#

