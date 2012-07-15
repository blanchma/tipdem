module LinkedInService

  def self.publish(post)
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
      @result
  end

  def self.analize(post)
  end

end