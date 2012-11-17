#encoding:utf-8
require "rubygems"
require "koala"
require "open-uri"
require "active_support/core_ext"
require "pp"
require "./location"
require "tap"


class FBApi

	def getFriendLocation

		token = ENV["FBAPITOKEN"]
		@rest = Koala::Facebook::API.new(token)

		fql =<<-"EOS"
			SELECT uid, name, pic_square , current_location FROM user WHERE uid = me()
			OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me())
		EOS

		puts token
		puts fql
		fql.tap{}
		friendsLocation=Array.new

		begin
			json = @rest.fql_query(fql).tap{}
			pp json
			json.each do |r|
				location = r["current_location"]
				unless location.nil?
					address = location["name"].split[0]
					uri = "http://www.geocoding.jp/api/?v=1.1&q='#{address}'"
					result = open(uri , "r:UTF-8")
					json = Hash.from_xml(result).to_json
					array = JSON.load(json)["result"]

					pp array
					unless array.nil? || array["error"].nil? || array["coordinate"].nil?
						latlng = Location.new(
							address,
							array["coordinate"]["lat"] , 
							array["coordinate"]["lng"]
						)

						friendsLocation << latlng
					end

					sleep 1
				end
			end
		rescue => err
			puts err
			puts "rescue"
		end


		return friendsLocation
	end

end