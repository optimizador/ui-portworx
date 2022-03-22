# config.ru
require './app'
require 'rack/protection'
require 'thin' 
disable :protection
run Sinatra::Application
