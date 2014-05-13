if ENV['RACK_ENV'] == 'production'
  deploy_to     = '/var/www/constxife.ru'
  sinatra_root  = "#{deploy_to}/current"
  pid_file      = "#{deploy_to}/shared/puma.pid"
  socket_file   = "unix://#{deploy_to}/shared/puma.sock"
  log_file      = "#{deploy_to}/shared/log/puma.log"
  err_log       = "#{deploy_to}/shared/log/puma_error.log"

  environment 'production'
  daemonize
  pidfile pid_file
  bind socket_file
  stdout_redirect log_file, err_log
  preload_app!
else
  sinatra_root = '.'
  port 3000
end

rackup "#{sinatra_root}/config.ru"
threads 1,1
workers 1