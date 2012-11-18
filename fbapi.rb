#encoding:utf-8
require "active_support/core_ext"
require "open-uri"
require "pp"
require "./location"

class FBApi

  def get_friend_locations

    token = ENV["FACEBOOK_TOKEN"] || raise("specify $FACEBOOK_TOKEN")
    @rest = Koala::Facebook::API.new(token)

    fql = <<-EOS
      SELECT uid, name, pic_square , current_location FROM user WHERE uid = me()
      OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me())
      OR uid IN (select current_location from user where uid = me())
    EOS


    friend_locations = []

    begin
      friends = @rest.fql_query(fql)
      friends.each do |friend|
        fb_location = friend["current_location"]
        next unless fb_location

        location_name = fb_location["name"].split[0]
        uri = "http://www.geocoding.jp/api/?v=1.1&q='#{location_name}'"
        result = open(uri, "r:UTF-8")
        friends = Hash.from_xml(result).to_json
        array = JSON.load(friends)["result"]

        pp array
        next unless array && array["error"].nil? && array["coordinate"]

        latlng = Location.new(
            location_name,
            array["coordinate"]["lat"],
            array["coordinate"]["lng"]
        )

        friend_locations << latlng
        #puts latlng.getname
        #puts latlng.getlat

        sleep 1
      end
    rescue => err
      puts "rescue"
      pp friend_locations
      #pp err
      return friend_locations
      #ensure
      #	puts "ensure"
      #	return friend_locations
    end

    friend_locations
  end

end
