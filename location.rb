#encoding:utf-8
require "rubygems"

class Location
	def initialize(lat,lng)
		@lat=lat
		@lng=lng
	end

	def getlat
		@lat
	end

	def getlng
		@lng
	end
end

def getFriendLocation

	l = Location.new(35.33386,139.404716)
	l2 = Location.new(35.181446, 136.906398)
	l3 = Location.new(34.958641,137.080297)

	return [l,l2,l3]
end