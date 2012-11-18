# encoding: utf-8
require "./env"
require "sinatra"

get "/" do
  fbapi = FBApi.new
  @friend_locations = fbapi.get_friend_locations
  @my_location = Location.new("hamamatsu", 34.710834, 137.726126)
  erb :index
end
