source 'https://rubygems.org'

gem 'bundler'
gem 'rake'

gem 'lotusrb',       '0.5'
gem 'lotus-model',   '>= 0.5'

gem 'pg'
gem 'haml'
gem 'semantic_logger', '~> 2.15'
gem 'r18n-core', '~> 2.0.4'

group :development do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
  gem 'airbrussh'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false
end

group :production do
  gem 'puma'
end
