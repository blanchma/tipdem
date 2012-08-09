require 'yaml'

redis_yaml = Rails.root + 'config/redis.yml'
redis_config = YAML.load_file(redis_yaml)
$redis = Redis.connect(redis_config[Rails.env])


