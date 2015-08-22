# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'sloboda-taxi'
set :repo_url, 'git@github.com:v7m/sloboda-taxi.git'
set :rvm_ruby_version, 'ruby-2.2.2'

set :linked_files, %w(config/database.yml)
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

set :unicorn_config_path, 'config/unicorn.rb'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end