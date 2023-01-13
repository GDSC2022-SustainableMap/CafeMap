# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
# Represents essential Repo information for API output
module CafeMap
  module Representer
    # Represent a Project entity as Json
    class Info < Roar::Decorator
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
    end
  end
end
