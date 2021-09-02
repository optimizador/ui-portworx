# config.ru
require './app'
require 'rack/protection'
disable :protection
run Sinatra::Application