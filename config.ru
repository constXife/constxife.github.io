require 'bundler'
Bundler.require
require 'sinatra/activerecord'
require 'erb'
require 'sinatra/asset_pipeline'
require 'i18n'
require 'i18n/backend/fallbacks'
require File.expand_path('lib/helpers', File.dirname(__FILE__))
require File.expand_path('app/blog', File.dirname(__FILE__))
require File.expand_path('app/models/post', File.dirname(__FILE__))

run Blog