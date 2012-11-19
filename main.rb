# encoding: utf-8
require "./env"
require "sinatra"
<<<<<<< HEAD
require "./location"
require "./fbapi"
require "pp"
require "tap"

class FBApi
	def getLocation
	end
end

get "/" do
	fbapi=FBApi.new
	@locations=fbapi.getFriendLocation.tap{}
	puts "fridnds location "
	puts @locations
	@mylocation=Location.new("hamamatsu",34.710834,137.726126)
	erb:index
=======

get "/" do
  fbapi = FBApi.new
  @friend_locations = fbapi.get_friend_locations
  @my_location = Location.new("hamamatsu", 34.710834, 137.726126)
  erb :index
>>>>>>> 8fd108fa40bc9ac8e251009cda878a669044ab0c
end
