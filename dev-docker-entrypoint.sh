#!/bin/sh

set -e 

echo "ENVIRONMENT: $RAILS_ENV" 

#check bundle
bundle check || bundle install

#remove pid from previous session (puma server)

rm -f $WEB_APP_PATH/tmp/pids/server.pid

# run anything by prepending bundle exec to the passed command
bundle exec rails assets:precompile
bundle exec ${@}