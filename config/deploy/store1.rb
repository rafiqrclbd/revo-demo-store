# User
set :user, 's-deployer-03'
set :service_user, 'one-s-service'
set :group, 'g_revo_rw'

# Connection settings
server 'store1.st.revoup.ru', user: fetch(:user), port: 2002, roles: %w[web app db]

# Default branch is :master
set :branch, ENV.fetch('branch', 'master')

# RVM settings
set :rvm_ruby_version, '2.5.3'

# Path settings
set :deploy_to, "/opt/#{fetch(:application)}"

fetch(:slackistrano_use_non_deploy_chat)
