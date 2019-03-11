# User
set :user, 's-deployer-02'
set :service_user, 'demostore'
set :group, 'g_revo_rw'

# SET  env
set :rails_env, 'production'

# Connection settings
server 'store.demo.revoup.ru', user: fetch(:user), port: 22, roles: %w[web app db]

# Default branch is :master
set :branch, ENV.fetch('branch', 'staging')

# RVM settings
set :rvm_ruby_version, '2.5.3'

# Path settings
set :deploy_to, "/opt/#{fetch(:application)}"

fetch(:slackistrano_use_non_deploy_chat)


after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    on roles(:web, :app), in: :sequence, wait: 5 do
      execute "sudo chown -R #{fetch(:service_user)}.#{fetch(:group)} /opt/#{fetch(:application)}"
      sleep 5
      execute "sudo systemctl stop #{fetch(:application)}"
      sleep 10
      execute "sudo systemctl start #{fetch(:application)}"
    end
  end
end

after 'deploy:restart', 'deploy:restart_nginx'
namespace :deploy do
  task :restart_nginx do
    on roles(:web, :app), in: :sequence, wait: 5 do
      execute 'sudo docker restart nginx'
    end
  end
end
