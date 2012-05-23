redis_yaml = Rails.root + 'config/redis.yml'

unless File.exists?(redis_yaml)
  raise "Missing Redis settings file #{redis_yaml}"
end

settings = YAML.load_file(redis_yaml)
config = settings.fetch(Rails.env, settings['default']).symbolize_keys

$redis = Redis.connect(config)
