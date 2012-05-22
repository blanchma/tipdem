# -*- encoding : utf-8 -*-
class Campaign < ActiveRecord::Base
  attr_accessor :logo_url
  delegate :mode, :pay, :commission, :to => :budget, :allow_nil => true

  #scope :active, :conditions => {:status => CampaignStatus::Active}
  scope :active, :conditions => ["status = ?",CampaignStatus::Active]
  scope :incomplete, :conditions => {:status => CampaignStatus::Incomplete}
  scope :non_active, :conditions => ["status != ?",CampaignStatus::Active ]
  scope :out_of_money, :conditions => ["status != ?",CampaignStatus::OutOfMoney ]

  #Invocar attr_accesible antes deh esto
  has_friendly_id :name, :allow_nil => true, :use_slug => true, :approximate_ascii => true

  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  belongs_to :reference, :polymorphic => true
  has_one :budget, :dependent => :destroy
  has_one :landing_page, :dependent =>  :destroy
  has_many :chains
  has_many :landing_page_hits
  has_many :client_page_hits
  has_many :posts
  has_many :revenues
  has_many :revenue_comissions
  has_many :promotions
  has_many :promotors, :through => :promotions, :source => :user
  has_many :payment_requests
  has_and_belongs_to_many :categories, :join_table => "categories_campaigns"

  has_many :campaign_notifieds
  has_many :users, :through => :campaign_notifieds

  #validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => true
  validates_length_of :name, :within => 5..30, :allow_nil => false, :allow_blank => false
  validates_length_of :description, :within => 10..350
  validates_length_of :default_message, :within => 5..110

  #http://railscasts.com/episodes/134-paperclip
  has_attached_file :logo, :styles => { :thumb => "50x50#",:small => "100x100", :landing => "300>x300" },
    :default_style => :small,
    :default_url => "/images/img_logo.png",
    :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"

  #validates_attachment_presence :logo, :message => "debe ser elegido"
  validates_attachment_size :logo, :less_than => 1.megabytes
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  # validate_on_create :validate_begin_date
  validate :validate_dates

  before_save :set_default_message
  after_create :incomplete!


  def validate_dates
    if have_end_date && begin_date > end_date
      errors.add(:end_date, "no puede ser anterior a la de inicio." )

    elsif have_end_date && end_date < Date.today
      errors.add(:end_date, "no puede ser anterior a hoy." )
    else
    end

    if begin_date_changed?
      if begin_date < Date.today
        errors.add(:begin_date, "no puede ser anterior a hoy." )
      end
    end
  end




  def promotion
    self.promotions.first(:conditions => {:user_id => user_id})
  end

  def tw_posts
    promotions.sum("tw_posts")
  end

  def tw_retweets
    promotions.sum("tw_retweets")
  end

  def fb_posts
    promotions.sum("fb_posts")
  end

  def fb_likes
    promotions.sum("fb_likes")
  end

  def fb_comments
    promotions.sum("fb_comments")
  end


  def incomplete!
    self.status = CampaignStatus::Incomplete
  end

  def completed!
    self.status = CampaignStatus::WaitingForPay
  end

  def paid!
    self.status = CampaignStatus::WaitingApproval
  end

  def disapprove!
    self.status = CampaignStatus::NotApproved
  end

  def active?
    self.status == CampaignStatus::Active
  end

  def visitable?
    self.status == CampaignStatus::Active
  end

  def editable?
    self.status != CampaignStatus::Incomplete
  end

  def activate!
    self.status = CampaignStatus::Active
  end

  def out_of_money?
    restante = budget.current
    if mode == CampaignMode::PayPerHit
      return budget.pay_per_client_page_hit > restante
    elsif mode == CampaignMode::PayPerClick
      return budget.pay_per_landing_page_hit > restante
    else
      return nil
    end
  end

  def out_of_money!
    if self.status != CampaignStatus::OutOfMoney
      CampaignStatusMailer.delay.deliver_out_of_money self
      self.status = CampaignStatus::OutOfMoney
    end
  end

  def expired?
    have_end_date && Date.today > end_date
  end

  def expired!
    self.status = CampaignStatus::Expired
  end

  def unstarted?
    Date.today < begin_date
  end

  def unstarted!
    self.status = CampaignStatus::NotBeginYet
  end

  def check_status
    if valid? == false
      self.status = CampaignStatus::Incomplete
    elsif unstarted?
      unstarted!
    elsif expired?
      expired!
    elsif out_of_money?
      out_of_money!
    else
      #nothing
    end

    return self.status
  end

  def link(user=nil, channel=nil, shorten=false)
    shorten=false if shorten
    if user && channel
      link = "#{APP_CONFIG['domain']}/see/#{self.friendly_id}/#{user.id}/#{channel}"
    elsif user
      link = "#{APP_CONFIG['domain']}/see/#{self.friendly_id}/#{user.id}"
    else
      link = "#{APP_CONFIG['domain']}/see/#{self.friendly_id}"
    end
    link = BITLY.shorten(link).short_url if shorten
    link
  end

  def eval_interest(user)
    matchs = user.category_ids & self.category_ids
    matchs.size / self.categories.count.to_f
  end




  def set_default_message
    if default_message.nil? || default_message.empty?
      self.default_message = self.description.slice(0,120) if self.description
    end
  end

end

