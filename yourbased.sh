#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive
bash script/travis_ebook_converters.sh
bundle install --jobs=3 --retry=3
bash script/travis_configure.sh
bash script/travis_elasticsearch_upgrade.sh
bash script/travis_multiple_redis.sh
bash script/travis_mysql.sh
RAILS_ENV=test bundle exec rake db:schema:load --trace
RAILS_ENV=test bundle exec rake db:migrate --trace
bundle exec $TEST_GROUP
