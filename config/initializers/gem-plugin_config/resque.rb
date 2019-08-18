require 'resque'

 if ENV['TRAVIS']
   rails_root = ENV['TRAVIS_BUILD_DIR']
   rails_env = 'test'
 else
   rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../../..'
   rails_env = ENV['RAILS_ENV'] || 'development'
 end

 redis_configs = YAML.load(ERB.new(File.read(rails_root + '/config/redis.yml')).result)
 Resque.redis = redis_configs['redis_resque'][rails_env]

 # in-process performing of jobs (for testing) doesn't require a redis server
 Resque.inline = ENV['RAILS_ENV'] == "test"

 Resque.after_fork do
   Resque.redis.client.reconnect
 end
