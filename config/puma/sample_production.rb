# Example puma config for production

# deploy_to  = ''
# rails_root = "#{deploy_to}/current"
# pid_file   = "#{deploy_to}/shared/tmp/pids/.pid"
# state_file = "#{deploy_to}/shared/tmp/pids/.state"
# socket_file= "unix://#{deploy_to}/shared/tmp/sockets/.sock"
# log_file   = "#{rails_root}/log/puma.log"
# err_log    = "#{rails_root}/log/puma_error.log"

# threads 2, 2
# environment 'production'
# pidfile pid_file
# state_path state_file
# stdout_redirect log_file, err_log
# bind socket_file
# rackup "#{rails_root}/config.ru"
#
# on_worker_boot do
#   # Worker specific setup for Rails 4.1+
#   # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
#   ActiveRecord::Base.establish_connection
# end
