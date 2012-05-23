require 'yaml'
require 'resque_scheduler'
require 'resque_scheduler/server'

resque_config = YAML.load_file(Rails.root + "config/resque.yml")

Resque.redis = resque_config[Rails.env]
Resque.redis.namespace = "resque:tipdem:#{Rails.env}"

#Resque.schedule = YAML.load_file(Rails.root + "config/resque_schedule.yml")