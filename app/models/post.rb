# -*- encoding : utf-8 -*-
class Post < ActiveRecord::Base
  HOUR_LIMIT=1
  DAY_LIMIT=3
  CAMPAIGN_LIMIT=5

  attr_accessor :promotion
  belongs_to :campaign, :class_name => "Campaign::Base", :foreign_key => "campaign_id"
  belongs_to :user

  scope :today, :conditions => ["created_at IS NOT NULL AND created_at > ?", Date.today.to_s(:db)]
  scope :yesterday, :conditions => ["post_at IS NULL OR last_post_at < ?)", Date.today]
  scope :not_failed, :conditions => ["status != ?", PostStatus::Error]
  scope :this_week, :conditions => ["posted_at > ?", Time.now.utc - (3600 * 24 * 7)]

  scope :when_day,  lambda { |day|
    begin_of_day = day - (day.hour * 3600) - (day.min * 60) - day.sec
    {  :conditions => ["when_post > ?", begin_of_day] }
  }

  scope :time_to_post,  lambda { |time|
    {  :conditions => ["when_post < ?", time] }
  }

  scope :waiting, :conditions => ["status = ?", PostStatus::Waiting]
  scope :published, :conditions => ["status = ?", PostStatus::Posted]
  scope :failed, :conditions => ["status = ?", PostStatus::Error]

  scope :facebook, :conditions => ["channel = ?", Channel::Facebook]
  scope :twitter, :conditions =>  ["channel =?",  Channel::Twitter]
  scope :linkedin, :conditions => ["channel =?",  Channel::LinkedIn]
  scope :email, :conditions =>    ["channel =?",  Channel::Email]

  scope :daily, lambda { |hour|
    {:conditions => ["daily = 1 AND hour_utc = ?", hour]}
  }

  scope :less_than, lambda {|quantity|
    {:conditions => ["counter < ?", quantity]}
  }

  before_create :waiting!#,:define_type

  after_create :promotion, :publish

  validate :validate_spam, :on => :create
  validates_presence_of :user, :campaign
  validates_inclusion_of :channel, :in => Channel.all
  validates_presence_of :message, :allow_blank => false, :on => :save

  def validate_spam
    return unless user && campaign && channel
    set_when_post

    posts = user.posts.not_failed.where(:channel => channel, :campaign_id => campaign_id)

    if posts.size > CAMPAIGN_LIMIT
      errors.add(:base, "No se pueden publicar más de #{CAMPAIGN_LIMIT} posts por campaña en la misma red.")
      return
    end

    if self.daily
      posts.each do |post|
        if post.daily && self.id && self.id != post.id
          errors.add(:base, "No puedes programar más post automáticos para esta red.")
        end
      end
    end

    posts_day = user.posts.not_failed.when_day(self.when_post).where(
      {:channel => channel, :campaign_id => campaign_id})

    if posts_day.count >= DAY_LIMIT
      errors.add(:base, "No se pueden publicar más de #{DAY_LIMIT} posts por día en la misma red")
    elsif hour_utc
      counter = 0
      posts_day.each do |post|
        counter+=1 if post.when_post.hour == hour_utc
      end
      if counter >= HOUR_LIMIT
        errors.add(:base, "No se puede publicar más de un mensaje a la misma hora")
      end
    end
  end


  def self.publish_daily?(user, campaign, channel=nil)
    if channel
      user.posts.daily.waiting.where(:channel => channel, :campaign_id => campaign.id).count > 0
    else
      user.posts.daily.waiting.where(:campaign_id => self.campaign.id).count > 0
    end
  end

  def self.stop_publish_daily(channel)
    posts = user.daily.posts.where(:campaign_id => self.campaign_id, :channel => channel)
    posts.each do |post|
      post.stop!
      post.save
    end
  end

  def self.max_length(channel=nil)
    if channel == Channel::Facebook
      300
    elsif channel == Channel::Twitter
      140
    else
      200
    end
  end

  def set_when_post
    puts "when_post"
    Time.zone = user.time_zone
    time_now = Time.zone.now
    if now
      self.when_post = time_now
      self.when_post = when_post - 3600 unless user.dst
    elsif hour
      time_mod = time_now  + ((self.hour - time_now.hour ) * 3600) - (time_now.min * 60)
      time_mod += 86400 if time_now.hour >= self.hour
      self.when_post =  time_mod
    else
    end
    self.hour_utc = self.when_post.hour
  end

  def promotion
    @promotion ||= user.promotions.find_or_create_by_campaign_id campaign_id if campaign
  end

  def link
    campaign.link({:user => user, :channel => channel})
  end

  def publish(now=false)
    puts "Send to Publish: #{when_post} (#{"now" if self.now})"

    if self.campaign
      if self.campaign.active? && (self.when_post < Time.now || now) && !self.posted?
        self.deliver

        if self.daily && self.counter <= CAMPAIGN_LIMIT
          new_post = self.clone
          new_post.counter+=1
          new_post.now=false
          new_post.clear!
          puts "Clonando"
          new_post.stop! if new_post.counter == CAMPAIGN_LIMIT
          cloned = new_post.save
          puts "Post duplicate #{new_post.counter} for tomorrow #{new_post.hour} hours"
        end
      end
    else
      self.destroy
    end
  end
  #handle_asynchronously :send_to_publish#, :run_at => Proc.new { 1.minutes.from_now }

  def posted!(post_id, response)
    self.status = PostStatus::Posted
    self.response = response
    self.post_id = post_id
    self.counter += 1
    self.posted_at = Time.now #- (self.user.dst ? 0 : 3600)
    puts "Post #{self.id } posted"
    return self.post_id
  end

  def fail?
    self.status == PostStatus::Error
  end

  def fail!(response)
    self.status = PostStatus::Error
    self.response = response
    self.attemps+= 1
    puts "Post #{self.id } fail (attemp: #{self.attemps}) -> #{response}"
  end

  def fail_oauth!
    self.status = PostStatus::Error
    self.respones = "#{t self.channel}Account nil"
    self.attemps+= 1
    puts "Post #{self.id } fail OAuth (attemp: #{self.attemps})"
  end

  def stop!
    self.daily = false
  end

  def waiting!
    self.status = PostStatus::Waiting unless self.status
  end

  def waiting?
    self.status == PostStatus::Waiting
  end

  def posted?
    self.status == PostStatus::Posted && self.post_id
  end

  def clear!
    self.posted_at = nil
    self.response = nil
    self.post_id = nil
    self.attemps = nil
    self.more = nil
    self.revenued = false
    self
  end

  def retrieve_data
    case channel
    when Channel::LinkedIn
      LinkedInService.query(self)
    when Channel::Facebook
      FacebookService.query(self)
    when Channel::Twitter
      TwitterService.query(self)
    end
  end

  def posted_at
    posted_at = read_attribute(:posted_at)
    posted_at = posted_at - 3600 unless posted_at.nil?  || user.dst
    posted_at
  end

  private
   def deliver
    case self.channel
    when Channel::LinkedIn
      LinkedInService.publish(self)
    when Channel::Facebook
      FacebookService.publish(self)
    when Channel::Twitter
      TwitterService.publish(self)
    end
  end


end


# == Schema Information
#
# Table name: posts
#
#  id          :integer(4)      not null, primary key
#  campaign_id :integer(4)
#  user_id     :integer(4)
#  channel     :string(255)
#  message     :string(255)
#  status      :string(255)
#  daily       :boolean(1)      default(FALSE)
#  hour        :integer(4)
#  hour_utc    :integer(4)
#  response    :string(255)
#  post_id     :string(255)
#  attemps     :integer(4)      default(0)
#  more        :string(255)
#  counter     :integer(4)      default(0)
#  targets     :string(255)
#  privacy     :string(255)
#  posted_at   :datetime
#  revenued    :boolean(1)
#  when_post   :datetime
#  type        :string(255)
#  retweets    :integer(4)      default(0)
#  likes       :integer(4)      default(0)
#  comments    :integer(4)      default(0)
#  now         :boolean(1)
#
