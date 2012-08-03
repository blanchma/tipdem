module LinkedInService

  def self.publish(post)
    account = post.user.linked_in_account
    post.destroy unless account
      begin
        client = post.user.linked_in
        account.friends_count = client.connections.count
        account.save if account.friends_count_changed?

        picture = Settings.domain + post.campaign.logo.url(:small) if Rails.env != 'development'
        link = post.campaign.link({:user => post.user, :channel => Channel::LinkedIn})

        feed = {
          :comment                => post.message,
          :title                  => post.campaign.name,
          :submitted-url          => link,
          :submitted-image-url    => picture,
          :description            => post.campaign.description
        }
        #shares["all"][6]["update_content"]["person"]["current_share"]["source"]

        response_hash = client.add_share(feed)
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

  def self.logger
    Rails.logger
  end

end