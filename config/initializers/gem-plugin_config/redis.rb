require 'redis_test_setup'
include RedisTestSetup

if ENV['TRAVIS']
  rails_root = ENV['TRAVIS_BUILD_DIR']
  rails_env = 'test'
else
  rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../../..'
  rails_env = ENV['RAILS_ENV'] || 'development'
end

unless ENV['TRAVIS']
  if rails_env == "test"
    # https://gist.github.com/441072
    start_redis!(rails_root, :cucumber)
  end
end

redis_configs = YAML.load(ERB.new(File.read(rails_root + '/config/redis.yml')).result)
redis_configs.each_pair do |name, redis_config|
  redis_host, redis_port = redis_config[rails_env].split(":")
  redis_connection = Redis.new(host: redis_host, port: redis_port)
  if ENV['DEV_USER']
    namespaced_redis = Redis::Namespace.new(ENV['DEV_USER'], redis: redis_connection)
    redis_connection = namespaced_redis
  end
  Object.const_set(name.upcase, redis_connection)
end
