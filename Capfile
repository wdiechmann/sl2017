# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/console'

require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/puma'
require 'capistrano/rails/assets' # for asset handling add
require 'capistrano/rails/migrations' # for running migrations

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }


#   https://github.com/capistrano/rails/tree/master/assets
#   https://github.com/capistrano/rails/tree/master/migrations
#
