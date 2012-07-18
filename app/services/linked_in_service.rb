module LinkedInService

  def self.publish(post)
    account = post.user.linked_in
      begin
        client = LinkedIn::Client.new(APP_CONFIG["linkedin_key"], APP_CONFIG["linkedin_secret"])
        client.authorize_from_access(account.token, account.secret)

        account.friends_count = client.connections.count
        account.save if account.friends_count_changed?

        url = post.campaign.link({:user => post.user, :channel => Channel::LinkedIn})
        response_hash = client.update_status("#{post.message} #{url}")
        logger.info "Response from LinkedIn = #{response_hash} for #{post.id}"
        @result = post.posted!(1, response_hash)
      rescue Exception => e
        logger.error e
        post.fail! e.message
        @result = e.message
      end

      post.save
      @result
  end

  def self.query(post)
  end

end