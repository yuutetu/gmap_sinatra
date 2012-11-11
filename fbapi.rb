#encoding:utf-8
require "rubygems"
require "koala"
require "open-uri"
require "active_support/core_ext"
require "pp"
require "./location"


token="AAACEdEose0cBAGazlBlTZBJkDZC2Tiw3VOYE2CeuJxDZCdtRR5zMAA1NrozsRHCfmwf2jvVtWhZCABF3ZB0XHohcaEkai9ExSXDD1Xk4XT085gqPYZAsAF"
@rest=Koala::Facebook::API.new(token)


fql=<<"EOS"
	SELECT uid, name, pic_square , current_location FROM user WHERE uid = me()
	OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me())
	OR uid IN (select current_location from user where uid = me())
EOS


json = @rest.fql_query(fql)
json.each do |r|
	location = r["current_location"]
	unless location.nil?
		address = location["name"].split[0]
		uri = "http://www.geocoding.jp/api/?v=1.1&q='#{address}'"
		result = open(uri , "r:UTF-8")
		json = Hash.from_xml(result).to_json
		array = JSON.load(json)["result"]

		unless array.nil? && array["error"].nil?
			latlng = Location.new(
				array["address"].split()[0],
				array["coordinate"]["lat"] , 
				array["coordinate"]["lng"]
			)

			#puts latlng.getname
			#puts latlng.getlat
		end

		sleep 1
	end
end