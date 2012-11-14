#encoding:utf-8
require "active_support/core_ext"
require "open-uri"
require "pp"
require "./location"

class FBApi

  def getFriendLocation

    token = ENV["FACEBOOK_TOKEN"] || raise("specify $FACEBOOK_TOKEN")
    @rest = Koala::Facebook::API.new(token)

    fql = <<-EOS
      SELECT uid, name, pic_square , current_location FROM user WHERE uid = me()
      OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me())
      OR uid IN (select current_location from user where uid = me())
    EOS


    friendsLocation = Array.new

    begin
      json = @rest.fql_query(fql)
      json.each do |r|
        location = r["current_location"]
        next unless location

        address = location["name"].split[0]
        uri = "http://www.geocoding.jp/api/?v=1.1&q='#{address}'"
        result = open(uri, "r:UTF-8")
        json = Hash.from_xml(result).to_json
        array = JSON.load(json)["result"]

        pp array
        next unless array && array["error"].nil? && array["coordinate"]

        latlng = Location.new(
            address,
            array["coordinate"]["lat"],
            array["coordinate"]["lng"]
        )

        friendsLocation << latlng
        #puts latlng.getname
        #puts latlng.getlat

        sleep 1
      end
    rescue => err
      puts "rescue"
      pp friendsLocation
      #pp err
      return friendsLocation
      #ensure
      #	puts "ensure"
      #	return friendsLocation
    end


    return friendsLocation
  end

end
