# Load DSL and set up stages
require 'capistrano/setup'
require 'capistrano/deploy'
require "capistrano/scm/git"

require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano3/unicorn'
require 'slackistrano/capistrano'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
