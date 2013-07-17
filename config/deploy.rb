require 'bundler/capistrano'
require 'rvm/capistrano'

set :application, "blog"
set :rails_env, "production"
set :domain, "constXife@oblakan.ru"
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :scm, :git # Используем git. Можно, конечно, использовать что-нибудь другое - svn, например, но общая рекомендация для всех кто не использует git - используйте git.
set :repository,  "git@bitbucket.org:constXife/blog.git" # Путь до вашего репозитария. Кстати, забор кода с него происходит уже не от вас, а от сервера, поэтому стоит создать пару rsa ключей на сервере и добавить их в deployment keys в настройках репозитария.
set :branch, "master" # Ветка из которой будем тянуть код для деплоя.
set :deploy_via, :remote_cache # Указание на то, что стоит хранить кеш репозитария локально и с каждым деплоем лишь подтягивать произведенные изменения. Очень актуально для больших и тяжелых репозитариев.

role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :copy_exclude, [ '.git' ]
set :keep_releases, 1
set :shared_children, shared_children + %w{public/system}

# Следующие строки необходимы, т.к. ваш проект использует rvm.
set :rvm_ruby_string, 'ruby-2.0.0'
set :rvm_type, :user
set :rake,            "rvm use #{rvm_ruby_string} do bundle exec rake"
set :bundle_cmd,      "rvm use #{rvm_ruby_string} do bundle"

#after 'deploy:update_code', :roles => :app do
#  # Здесь для примера вставлен только один конфиг с приватными данными - database.yml. Обычно для таких вещей создают папку /srv/myapp/shared/config и кладут файлы туда. При каждом деплое создаются ссылки на них в нужные места приложения.
#  run "rm -f #{current_release}/config/database.yml"
#  run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
#end

# Далее идут правила для перезапуска unicorn. Их стоит просто принять на веру - они работают.
# В случае с Rails 3 приложениями стоит заменять bundle exec unicorn_rails на bundle exec unicorn
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end