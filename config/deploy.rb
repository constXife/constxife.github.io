require 'bundler/capistrano'
require 'puma/capistrano'
require 'rvm/capistrano'

set :application, "blog"
set :rails_env, "production"
set :domain, "constXife@lunkserv.ru"
set :deploy_to, "/var/www/constxife.ru"
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :scm, :git
set :repository,  "git@bitbucket.org:constXife/blog.git"
set :branch, "master"
set :deploy_via, :remote_cache

role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :copy_exclude, [ '.git' ]
set :keep_releases, 1
set :shared_children, shared_children + %w{public/system}

set :rvm_ruby_string, 'ruby-2.0.0'
set :rvm_type, :user
set :rake,            "rvm use #{rvm_ruby_string} do bundle exec rake"
set :bundle_cmd,      "rvm use #{rvm_ruby_string} do bundle"

after 'deploy:update', 'deploy:cleanup'