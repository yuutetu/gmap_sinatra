#encoding:utf-8
require "./fbapi"

class Location
  def initialize(name, lat, lng)
    @name = name
    @lat = lat
    @lng = lng
  end

  def getname
    @name
  end

  def getlat
    @lat
  end

  def getlng
    @lng
  end
end

