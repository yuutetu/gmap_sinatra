#encoding:utf-8
require "rubygems"
require "sinatra"

class Location
	def lat
		@lat=34.710834
	end

	def lng
		@lng=137.726126
	end
end


get "/" do
	@location=Location.new
	erb:index
end

