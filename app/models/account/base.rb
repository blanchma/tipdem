# -*- encoding : utf-8 -*-
module Account
  class Base < ActiveRecord::Base
    self.table_name =  "accounts"
    serialize :auth_hash
    belongs_to :user

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

    def self.from_omniauth(auth_hash)
      if (account = find_by_uid(auth_hash['uid']))
        account.auth_hash = auth_hash
        account.apply_omniauth(auth_hash)
        account.save
        account
      else
        create_from_omniauth(auth_hash)
      end
    end

    def self.create_from_omniauth(auth_hash)
      create do |account|
        account.auth_hash = auth_hash
        account.from_omniauth(auth_hash)
      end
    end

    def apply_omniauth(auth_hash)
      self.uid        = auth_hash['uid']
      self.token      = auth_hash['credentials']['token']
      self.secret     = auth_hash['credentials']['secret']
      self.provider   = auth_hash['provider']
    end


  end
end
# == Schema Information
#
# Table name: accounts
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  uid             :string(255)
#  provider        :string(255)
#  access_token    :string(255)
#  secret          :string(255)
#  login           :string(255)
#  name            :string(255)
#  friends         :integer(4)
#  auth_hash       :text
#  created_at      :datetime
#  updated_at      :datetime
#  followers_count :integer(4)
#  following_count :integer(4)
#  type            :string(255)
#

