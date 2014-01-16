deploy_to  = "/var/www/constxife.ru"
rails_root = "#{deploy_to}/current"
pid_file   = "#{deploy_to}/shared/pids/puma.pid"
state_file = "#{deploy_to}/shared/pids/puma.state"
socket_file= "unix://#{deploy_to}/shared/puma.sock"
log_file   = "#{rails_root}/log/puma.log"
err_log    = "#{rails_root}/log/puma_error.log"

threads 1,1
workers 1
environment 'production'
daemonize
pidfile pid_file
state_path state_file
stdout_redirect log_file, err_log
bind socket_file
preload_app!