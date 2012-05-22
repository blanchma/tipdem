# -*- encoding : utf-8 -*-
class RecommendCampaignJob

  def self.perform
    cron_log "Starting Recommendations Job..."
    User.verified.email_with_recommendations.each do |user|
      cron_log "Looking in #{user.email}"
      campaign_ids = user.categories.collect do |category|
        category.campaigns.active.all(:select => "id").collect do |campaign|
          campaign.id
        end
      end
      
      campaign_ids.flatten!
      cron_log "ids collected: #{campaign_ids }"

      unique_campaign_ids = campaign_ids.uniq
      cron_log "unique ids collected: #{unique_campaign_ids}"

      if unique_campaign_ids
        non_repeated_ids = unique_campaign_ids  - user.recommended_campaign_ids
        cron_log "non repatead ids: #{non_repeated_ids}"

        scored_ids = non_repeated_ids.collect do |id|
          [id, campaign_ids.count(id)]
        end
        
        scored_ids.sort! {|x,y| y[0] <=> x[0] }
        
        campaign_ids_for_notification = scored_ids.first(5).map{|spair| spair[0]}

        cron_log "#{campaign_ids_for_notification.size} to notify"
        if campaign_ids_for_notification.size > 0
          @campaigns = campaign_ids_for_notification.collect do |id|
            campaign = Campaign.find id
            cron_log "      Adding #{campaign.name} with categories: #{campaign.categories}"
            user.recommended_campaign_ids << campaign.id
            user.save
            campaign
          end
          cron_log "        Sending recommendation to #{user.email}"
          ContactMailer.deliver_recommendation_email(user, @campaigns)
          
        end
      end
    end
  end
end

