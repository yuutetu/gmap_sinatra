#encoding:utf-8

#require "rubygems"
require "./fbapi"

class Location
	attr_accessor :name , :lat , :lng

	def initialize(name,lat,lng)
		@name , @lat , @lng = name , lat , lng
	end

end

def getFriendLocation
	l = Location.new("tokyo",35.33386,139.404716)
	l2 = Location.new("nagoya",35.181446, 136.906398)
	l3 = Location.new("anjo",34.958641,137.080297)
	return [l,l2,l3]
end