#encoding:utf-8
require "rubygems"
require "open-uri"
require "koala"
require "./location"
require "active_support/core_ext"


class FBApi

	def getFriendLocation

		token = ENV["FBAPITOKEN"]
		@rest = Koala::Facebook::API.new(token)

		fql =<<-"EOS"
			SELECT uid, name, pic_square , current_location FROM user WHERE uid = me()
			OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me())
			AND current_location <> ''
			LIMIT 1,20
		EOS

	
		friendsLocation=Array.new

		begin
			json = @rest.fql_query(fql)
			json.each do |r|
				location = r["current_location"]

				unless location.nil?
					address = location["name"].split[0]
					latlng = getLatlng(address)

					puts latlng
					
					unless latlng.nil? && latlng["error"].nil?
						latlng = Location.new(
							address,
							latlng["coordinate"]["lat"] , 
							latlng["coordinate"]["lng"]
						)
						friendsLocation << latlng
					end

					sleep 5
				end
			end
		rescue => err
			puts err
			puts "rescue"
		end

		return friendsLocation.tap{}
	end

	def getLatlng(place)
		uri = "http://www.geocoding.jp/api/?v=1.1&q='#{place}'"
		puts uri
		xml = open(uri , "r:UTF-8")
		return JSON.load(Hash.from_xml(xml).to_json)["result"]
	end

end