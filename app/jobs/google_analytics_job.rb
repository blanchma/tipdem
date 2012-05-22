# -*- encoding : utf-8 -*-
require 'lib/analytics'

class GoogleAnalyticsJob
  def self.get_analytics_daily
    cron_log "#{Time.now}: Looking for google analytics info..."
    analytics = Analytics.new
    cron_log analytics.get_data(Time.now - 86400)
  end
end

