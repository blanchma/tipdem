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