# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'blog'
set :repo_url, 'git@github.com:constXife/blog.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/constxife/blog'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/puma.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :puma_conf,  "#{shared_path}/config/puma.rb"
set :puma_state, "#{shared_path}/tmp/pids/blog.state"
set :puma_pid, "#{shared_path}/tmp/pids/blog.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/blog.sock"

set :keep_releases, 1

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
