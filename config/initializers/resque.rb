require 'yaml'
require 'resque_scheduler'

redis_yaml = Rails.root + 'config/redis.yml'
Resque.redis = $redis

#Resque.schedule = YAML.load_file(Rails.root + "config/resque_schedule.yml")