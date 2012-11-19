#encoding:utf-8
require "rubygems"
require "sinatra"
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
end
