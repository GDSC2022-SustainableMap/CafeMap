# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

module CafeMap
  module Entity
    # Domain entity for any coding projects
    class Cluster < Dry::Struct
      include Dry.Types

      attribute :infoid,              Coercible::String
      attribute :name,                Strict::String
      attribute :city,                Strict::String
      attribute :wifi,                Nominal::Float
      attribute :seat,                Nominal::Float
      attribute :quiet,               Nominal::Float
      attribute :tasty,               Nominal::Float
      attribute :cheap,               Nominal::Float
      attribute :music,               Nominal::Float
      attribute :url,                 Strict::String
      attribute :address,             Strict::String
      attribute :latitude,            Strict::String
      attribute :longitude,           Strict::String
      attribute :limited_time,        Strict::String
      attribute :socket,              Strict::String
      attribute :standing_desk,       Strict::String
      attribute :mrt,                 Strict::String
      attribute :open_time,           Strict::String
      attribute :place_id, Strict::String
      # attribute :name, Strict::String
      attribute :formatted_address, Strict::String
      attribute :business_status, Strict::String

      attribute :location_lat,  Coercible::String
      attribute :location_lng,  Coercible::String

      attribute :viewport_ne_lat,  Coercible::String
      attribute :viewport_ne_lng,  Coercible::String
      attribute :viewport_sw_lat,  Coercible::String
      attribute :viewport_sw_lng,  Coercible::String

      attribute :rating, Coercible::Float

      attribute :compound_code, Coercible::String
      attribute :global_code, Coercible::String

      attribute :user_ratings_total, Strict::Integer
      attribute :types, Coercible::String
      attribute :cluster, Coercible::String

      def to_attr_hash
        to_hash
      end
    end
  end
end
