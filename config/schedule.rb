# -*- encoding : utf-8 -*-
# http://en.wikipedia.org/wiki/Cron

set :whenever_command, "bundle exec whenever"

set :output, {:error => 'log/cron_error.log', :standard => 'log/cron.log'}

#set :output, {:error => 'log/cron_error.log', :standard => 'log/cron.log'}
env :MAILTO, 'tute.unique@gmail.com'

job_type :delayed, "cd :path && Rails.env=:environment ruby script/delayed_job :task :output"
job_type :runner,  "cd :path && ruby script/runner -e :environment ':task' :output"

every 1.day do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner "GoogleAnalyticsJob.get_analytics_daily"
  runner "RecommendCampaignJob.perform"
end

every 10.minutes do
  delayed "check"
end

every 30.minutes do
  runner "PostJob.publish"
end

every 1.hour do
  runner "PostJob.retry"
  runner "PostJob.retrieve_data"
  runner "CheckCampaingStatusJob.perform"
end

