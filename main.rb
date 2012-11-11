#encoding:utf-8
require "rubygems"
require "sinatra"
require "./location"

class FBApi
	def getLocation
	end
end

get "/" do
	@locations = getFriendLocation
	@mylocation=Location.new("hamamatsu",34.710834,137.726126)
	erb:index
end
