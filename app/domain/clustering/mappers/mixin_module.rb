# frozen_string_literal: true

# Using mixin to avoid rubocop show "Too many method inside a class"
module ClusterMixinGeo
  # Infos about  geometry infomration except rank
  def infoid
    @data['id']
  end

  def name
    @data['name']
  end

  def city
    @data['city']
  end

  def url
    @data['url']
  end

  def address
    @data['address']
  end

  def latitude
    @data['latitude']
  end

  def longitude
    @data['longitude']
  end

  def limited_time
    @data['limited_time']
  end

  def socket
    @data['socket']
  end

  def standing_desk
    @data['standing_desk']
  end

  def mrt
    @data['mrt']
  end

  def open_time
    @data['open_time']
  end
end

# Using mixin to avoid rubocop show "Too many method inside a class"
module ClusterMixinRank
  # Infos about  rank
  def wifi
    @data['wifi']
  end

  def seat
    @data['seat']
  end

  def quiet
    @data['quiet']
  end

  def tasty
    @data['tasty']
  end

  def cheap
    @data['cheap']
  end

  def music
    @data['music']
  end

  def place_id
    @data['place_id']
  end

  def name
    @data['name']
  end

  def formatted_address
    @data['formatted_address']
  end

  def business_status
    @data['business_status']
  end

  def location_lat
    @data['location_lat']
  end

  def location_lng
    @data['location_lng']
  end

  def viewport_ne_lat
    @data['viewport_ne_lat']
  end

  def viewport_ne_lng
    @data['viewport_ne_lng']
  end

  def viewport_sw_lat
    @data['viewport_sw_lat']
  end

  def viewport_sw_lng
    @data['viewport_sw_lng']
  end

  def compound_code
    @data['compound_code']
  end

  def global_code
    @data['global_code']
  end

  def rating
    @data['rating']
  end

  def user_ratings_total
    @data['user_ratings_total']
  end

  def types
    @data['types']
  end

  def cluster
    @data['cluster']
  end
end
