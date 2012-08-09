# -*- encoding : utf-8 -*-
module Account
  class Twitter < Base

    def from_omniauth(auth_hash)
      super
      self.login               = auth_hash['info']['nickname']
      #self.picture_url        = auth_hash['info']['image']
      self.name                = auth_hash['info']['name']
    end

    def account_url
      "http://twitter.com/#{self.login}"
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

