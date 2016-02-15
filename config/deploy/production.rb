#User
set :user, "deployer"

#Connection settings
server 'store.revoup.ru', user: fetch(:user), port: 2002, roles: %w{web app db}

# Default branch is :master
set :branch, 'master'

#RVM settings
set :rvm_ruby_version, "2.1.5"

#Path settings
set :deploy_to, "/home/#{fetch(:user)}/www/#{fetch(:application)}"