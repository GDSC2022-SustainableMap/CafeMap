# frozen_string_literal: true

# Using mixin to avoid rubocop show "Too many method inside a class"
module StoreMixin
  # Infos about  rank
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
    @data['geometry']['location']['lat']
  end

  def location_lng
    @data['geometry']['location']['lng']
  end

  def viewport_ne_lat
    @data['geometry']['viewport']['northeast']['lat']
  end

  def viewport_ne_lng
    @data['geometry']['viewport']['northeast']['lng']
  end

  def viewport_sw_lat
    @data['geometry']['viewport']['southwest']['lat']
  end

  def viewport_sw_lng
    @data['geometry']['viewport']['southwest']['lng']
  end

  def compound_code
    @data['plus_code']['compound_code']
  end

  def global_code
    @data['plus_code']['global_code']
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
end
