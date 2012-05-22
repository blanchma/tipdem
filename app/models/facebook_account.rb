# -*- encoding : utf-8 -*-
class FacebookAccount < Authentication

  def publish(post)


    token =  self.token
    picture = "http://tipdem.com/images/logo.png"
    picture = APP_CONFIG['domain'] + post.campaign.logo.url(:small) if Rails.env != 'development'

    feed = {
      :message     => post.message,
      :name        => post.campaign.name,
      :link        => post.campaign.link(post.user, Channel::Facebook,true),
      :picture     => picture,
      :description => post.campaign.description,
      :caption     => APP_CONFIG['domain']
    }
    begin
      fb_session = MiniFB::OAuthSession.new(token, 'es_ES')
      self.friends_count = fb_session.me.friends.data.count
      self.save if self.friends_count_changed?
      response_hash = fb_session.post('me',:type => :feed, :params => feed)
      @result = post.posted!(response_hash.id, response_hash)

    rescue Exception => e
      logger.error e
      @result = e.message
      post.fail!(e.message)
    end

    post.save
    return @result
  end

  def retrieve_data(post)

    if post.posted?
      response = MiniFB.get(self.token, self.post_id)
      post.comments= response.comments ? response.comments[:count] : 0
      post.likes= response.likes ? response.likes[:count] :  0
      puts "Retrieved #{response.comments } comments."
      puts "Retrieved #{response.likes } likes."
      changed = post.comments_changed? || post.likes_changed?
      post.save if changed
    end

    return changed
  end
end

