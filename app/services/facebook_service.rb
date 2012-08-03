module FacebookService

  def self.publish(post)
    account = post.user.facebook_account
    post.destroy unless account

    picture = Settings.domain + post.campaign.logo.url(:small) if Rails.env != 'development'
    link = post.campaign.link({:user => post.user, :channel => Channel::Facebook})
    feed = {
      :message     => post.message,
      :name        => post.campaign.name,
      :link        => link,
      :picture     => picture,
      :description => post.campaign.description,
      :caption     => Settings.domain
    }
    feed.delete(:link) if Rails.development?
    feed.delete(:picture) if Rails.development?

    begin
      fb_session = post.user.facebook
      account.friends_count = fb_session.me.friends.data.count
        account.save if account.friends_count_changed?
      response_hash = fb_session.post('me',:type => :feed, :params => feed)
      @result = post.posted!(response_hash.id, response_hash)
    rescue Exception => e
      logger.error e
      @result = e.message
      post.fail!(e.message)
    end

    post.save
    @result
  end

  def self.query(post)
    account = post.user.facebook_account
    if post.posted?
      response = MiniFB.get(account.token, post.post_id)
      post.comments= response.comments ? response.comments[:count] : 0
      post.likes= response.likes ? response.likes[:count] :  0
      logger "Retrieved #{response.comments } comments."
      logger.info "Retrieved #{response.likes } likes."
      changed = post.comments_changed? || post.likes_changed?
      post.save if changed
    end
    changed
  end

  def self.logger
    Rails.logger
  end

end
