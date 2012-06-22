# -*- encoding : utf-8 -*-

class FacebookAnalytics < ActiveRecord::Base

  def initialize
    fb_app_id=APP_CONFIG['facebook_app_id']
    fb_secret = APP_CONFIG['facebook_secret']

    access_url = "https://graph.facebook.com/oauth/access_token?client_id=#{fb_app_id}&client_secret=#{fb_secret}&grant_type=client_credentials"

    response_token = HTTParty.get access_url
    access_token = response_token.split('=')[1]
    insight_url = url_app = "https://graph.facebook.com/#{fb_app_id}/insights?access_token=#{access_token}"

    response_insight = HTTParty.get(URI.escape insight_url)

    hashie_insight = Hashie::Mash.new response_insight

    
  end


end

# == Schema Information
#
# Table name: facebook_analytics
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

