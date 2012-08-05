require 'yaml'
require 'resque_scheduler'

redis_yaml = Rails.root + 'config/redis.yml'

unless File.exists?(redis_yaml)
  raise "Missing Redis settings file #{redis_yaml}"
end

redis_config = YAML.load_file(redis_yaml)
$redis = Redis.connect(redis_config[Rails.env])
Resque.redis = $redis
#Resque.schedule = YAML.load_file(Rails.root + "config/resque_schedule.yml")