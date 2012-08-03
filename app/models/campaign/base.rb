module Campaign
  class Base < ActiveRecord::Base
    self.table_name = "campaigns"
    include AASM
    include Campaign::Status

    scope :inactive, -> { where("status != ?", "active")}
    #Invocar attr_accesible
    has_friendly_id :name, :allow_nil => true, :use_slug => true, :approximate_ascii => true

    belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
    belongs_to :reference, :polymorphic => true

    has_one :budget, :foreign_key => "campaign_id", :dependent => :destroy
    has_one :landing_page, :foreign_key => "campaign_id", :dependent =>  :destroy

    has_many :chains, :foreign_key => 'campaign_id'
    has_many :landing_page_hits, :foreign_key => "campaign_id"
    has_many :client_page_hits, :foreign_key => "campaign_id"
    has_many :posts, :foreign_key => "campaign_id"
    has_many :revenues, :foreign_key => "campaign_id"
    has_many :revenue_comissions, :foreign_key => "campaign_id"
    has_many :promotions, :foreign_key => "campaign_id"
    has_many :promotors, :through => :promotions, :source => :user
    has_many :payment_requests, :foreign_key => "campaign_id"
    has_many :campaign_notifieds, :foreign_key => "campaign_id"
    has_many :users, :through => :campaign_notifieds

    has_and_belongs_to_many :categories, :join_table => "categories_campaigns", :foreign_key => "campaign_id"

    has_many :rewards, foreign_key: "campaign_id"
    has_many :products, through: :rewards

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

    attr_accessor :logo_url
    delegate :mode, :pay, :commission, :to => :budget, :allow_nil => true
    attr_protected :user_id

    before_create :build_default


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

    def link(opts={})
      opts = {:shorten => true}.merge! opts={}
      link = "#{APP_CONFIG['domain']}/see/#{self.friendly_id}"
      link += "/#{user.id}/" if opts[:user]
      link += "/#{channel}/" if opts[:channel]
      link = BITLY.shorten(link).short_url if opts[:sorten]
      link
    end

    def interestedness(user)
      matchs = user.category_ids & self.category_ids
      matchs.size / self.categories.count.to_f
    end

    def authorized?(user)
      self.user_id == user.id || user.admin
    end

    private
    def build_default
      if default_message.nil? || default_message.empty?
        self.default_message = self.description.slice(0,120) if self.description
      end
      self.valid? ? update_status : self.status=:inactive
    end
  end

end
# == Schema Information
#
# Table name: campaigns
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  name              :string(255)
#  description       :string(255)
#  status            :string(255)
#  default_message   :string(255)
#  have_end_date     :boolean(1)
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer(4)
#  reference_id      :integer(4)
#  reference_type    :string(255)
#  begin_date        :date
#  end_date          :date
#  created_at        :datetime
#  updated_at        :datetime
#

