# -*- encoding : utf-8 -*-
module Account
  class LinkedIn < Base

    def publish(post)

      begin
        client = LinkedIn::Client.new(APP_CONFIG["linkedin_key"], APP_CONFIG["linkedin_secret"])
        client.authorize_from_access(self.token, self.secret)

        self.friends_count = client.connections.count
        self.save if self.friends_count_changed?

        url = post.campaign.link(user, Channel::LinkedIn,true)
        response_hash = client.update_status("#{post.message} #{url}")
        logger.info "Resp LinkedIn = #{response_hash}"
        @result = post.posted!(1, response_hash)

      rescue Exception => e
        logger.error e
        post.fail! e.message
        @result = e.message
      end


      post.save
      return @result
    end

    def assign_account_info(auth_hash)
      #self.picture_url         = auth_hash['info']['image']
      self.name                = auth_hash['info']['first_name']
    end

    def account_url
      "http://www.linkedin.com/profile/view?id=#{self.remote_account_id}"
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

