# encoding: utf-8
require "bundler"
Bundler.require

require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths += %w[app]

get "/" do
  fbapi = FBApi.new
  @friend_locations = fbapi.get_friend_locations
  @my_location = Location.new("hamamatsu", 34.710834, 137.726126)
  erb :index
end
