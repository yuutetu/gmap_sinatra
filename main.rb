#encoding:utf-8
require "rubygems"
require "sinatra"
require "./location"

=begin
class Location
	def lat
		@lat=34.710834
	end

	def lng
		@lng=137.726126
	end
end
=end



get "/" do
	@locations = getFriendLocation
	#@location=Location.new
	erb:index
end
