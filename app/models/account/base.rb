# -*- encoding : utf-8 -*-
module Account
  class Base < ActiveRecord::Base
    set_table_name "accounts"
    serialize :auth_hash
    belongs_to :user

    def generate_token!
      self.verify_token = ActiveSupport::SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
    end

    def channel
      channel = case self.provider
        when "twitter" then Channel::Twitter
        when "facebook" then Channel::Facebook
        when "linked_in" then Channel::LinkedIn
      end
      channel
    end

    def find(auth_hash)
      find_by_uid(auth_hash['uid'])
    end

    def self.find_or_create_from_auth_hash(auth_hash)
      if (account = find_by_uid(auth_hash['uid']))
        account.auth_hash = auth_hash
        account.assign_account_info(auth_hash)
        account.save
        account
      else
        create_from_auth_hash(auth_hash)
      end
    end

    def self.create_from_auth_hash(auth_hash)
      create do |account|
        account.auth_hash = auth_hash
        account.assign_base_info(auth_hash)
        account.assign_account_info(auth_hash)
      end
    end

    def create_user
      puts "create_user"
      user = User.new(:password => Devise.friendly_token[0...10])
      user.confirmed_at = Time.now.utc
      user.assign_user_info(self.auth_hash)
      user.accounts << self
      user.save!
      user
    end

    def assign_base_info(auth_hash)
      self.uid   = auth_hash['uid']
      self.access_token        = auth_hash['credentials']['token']
      self.secret = auth_hash['credentials']['secret']
      self.provider = auth_hash['provider']
    end


  end
end