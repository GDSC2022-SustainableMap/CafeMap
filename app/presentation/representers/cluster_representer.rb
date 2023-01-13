# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
# Represents essential Repo information for API output
module CafeMap
  module Representer
    # Represent a Project entity as Json
    class Cluster < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property      :infoid
      property      :name
      property      :city
      property      :wifi
      property      :seat
      property      :quiet
      property      :tasty
      property      :cheap
      property      :music
      property      :url
      property      :address
      property      :latitude
      property      :longitude
      property      :limited_time
      property      :socket
      property      :standing_desk
      property      :mrt
      property      :open_time
      # property      :info_id
      property      :place_id
      # property      :name
      property      :formatted_address
      property      :business_status
      property      :location_lat
      property      :location_lng
      property      :viewport_ne_lat
      property      :viewport_ne_lng
      property      :viewport_sw_lat
      property      :viewport_sw_lng
      property      :compound_code
      property      :global_code
      property      :rating
      property      :user_ratings_total
      property      :types
      property      :cluster
    end
  end
end
