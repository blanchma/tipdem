# -*- encoding : utf-8 -*-
class TwitterAccount < Authentication
  
  def publish(post)
    
    token = self.token
    secret = self.secret
    begin
      
      
      client = Twitter::Client.new(:oauth_token => token, :oauth_token_secret => secret )
      
      self.followers_count = client.followers.users.count
      self.save if self.followers_count_changed?

      url = post.campaign.link(user, Channel::Twitter,true)
      response_hash = client.update("#{post.message} #{url} - spon")
      logger.info "Resp Twitter = #{response_hash}"
      @result= post.posted!(response_hash.id, response_hash)
      
      
    rescue Exception => e
      logger.error e
      post.fail! e.message
      @result = e.message
    end
    
    post.save
    return @result
  end

  def retrieve_data(post)
    if post.posted?
      retweets= self.retweets
      retweet_count = Twitter.status(self.post_id).retweet_count
      puts "Retrieved #{retweet_count} retweets"
      self.retweets= retweet_count if retweet_count
      post.save
    end

    return
  end

end
