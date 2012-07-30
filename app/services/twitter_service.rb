module TwitterService

  def self.publish(post)
    account = post.user.twitter_account
    post.destroy unless account

    begin
      client = post.user.twitter
      url = post.campaign.link({:user => post.user, :channel => Channel::Twitter})
      response_hash = client.update("#{post.message} #{url}")
      logger.info "Response from Twitter = #{response_hash} for #{post.id}"
      @result= post.posted!(response_hash.id, response_hash)
    rescue Exception => e
      logger.error e
      post.fail! e.message
      @result = e.message
    end

    post.save
    @result
  end

  def self.query(post)
    if post.posted?
      begin
        post.retweets = Twitter.status(post.post_id).retweet_count
        logger "Retrieved #{post.retweets} retweets"
        post.save if post.retweets_changed?
      rescue Twitter::Error::NotFound => not_found
        post
      end
    end
  end

  def self.logger
    Rails.logger
  end

end
