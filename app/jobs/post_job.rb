# -*- encoding : utf-8 -*-
class PostJob
  def self.publish
    cron_log "Looking for posts to publish"

    Post.waiting.time_to_post(Time.now).each do |post|
      cron_log post.delay.send_to_publish
    end
  end



  def self.retrieve_data
    cron_log "Starting to Check Posts"    
    Post.this_week.published.each do |post|
      cron_log "Retrieving data from post #{post.id}"
      post.delay..retrieve_data
    end
  end

  def self.retry
    cron_log "Retrying to Check Posts"
    Post.failed.time_to_post(Time.now).each do |post|
      cron_log "Retrieving data from post #{post.id}"
      cron_log post.send_to_publish
    end
  end
end
