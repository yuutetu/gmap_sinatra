#encoding:utf-8
require "active_support/core_ext"
require "open-uri"
require "pp"
require "./location"

class FBApi
  def get_friend_locations
    friend_locations = []

    begin
      friends = get_friends

      friends.each do |friend|
        fb_location = friend["current_location"]
        next unless fb_location

        location_name = fb_location["name"].split[0]
        location = find_coordinate(location_name)

        next unless location

        friend_locations << location
        #puts location.name
        #puts location.latitude

        sleep 1
      end
    rescue => err
      puts "rescue"
      pp friend_locations
      #pp err
      return friend_locations
      #ensure
      # puts "ensure"
      # return friend_locations
    end

    friend_locations
  end

  def get_friends
    facebook_api.fql_query(<<-EOS)
        SELECT uid, name, pic_square , current_location FROM user WHERE uid = me()
        OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me())
        OR uid IN (select current_location from user where uid = me())
    EOS
  end

  def facebook_api
    token = ENV["FACEBOOK_TOKEN"] || raise("specify $FACEBOOK_TOKEN")
    Koala::Facebook::API.new(token)
  end

  def find_coordinate(location_name)
    uri = "http://www.geocoding.jp/api/?v=1.1&q='#{location_name}'"
    result_xml = open(uri, "r:UTF-8")
    result_json = Hash.from_xml(result_xml).to_json
    result = JSON.load(result_json)["result"]

    pp result

    if result && result["error"].nil? && result["coordinate"]
      Location.new(
          location_name,
          result["coordinate"]["lat"],
          result["coordinate"]["lng"]
      )
    else
      nil
    end
  end

end
