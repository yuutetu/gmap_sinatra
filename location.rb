#encoding:utf-8

#require "rubygems"
require "./fbapi"

class Location
	attr_accessor :name , :lat , :lng

	def initialize(name,lat,lng)
		@name , @lat , @lng = name , lat , lng
	end

end

