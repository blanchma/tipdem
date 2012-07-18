module TwitterService

  def self.publish(post)
    account = post.user.twitter

    begin
      client = Twitter::Client.new(:oauth_token => account.token,
        :oauth_token_secret => account.secret )

      account.followers_count = client.followers.users.count
      account.save if account.followers_count_changed?

      url = post.campaign.link({:user => post.user, :channel => Channel::Twitter})
      response_hash = client.update("#{post.message} #{url} - spon")
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
      retweets= self.retweets
      retweet_count = Twitter.status(self.post_id).retweet_count
      puts "Retrieved #{retweet_count} retweets"
      self.retweets= retweet_count if retweet_count
      post.save
    end
  end

  def self.logger
    Rails.logger
  end

end