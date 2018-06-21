# User
set :user, 'deployer'

# Connection settings
server '10.1.2.106', user: fetch(:user), port: 2002, roles: %w{web app db}

# Default branch is :master
set :branch, ENV.fetch('branch', 'staging')

# RVM settings
set :rvm_ruby_version, '2.5.1'

# Path settings
set :deploy_to, "/home/#{fetch(:user)}/www/#{fetch(:application)}"

fetch(:slackistrano_use_non_deploy_chat)
