# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module CafeMap
  module Entity
    # Domain entity for stores
    class Store < Dry::Struct
      include Dry.Types

      attribute :place_id, Strict::String
      attribute :name, Strict::String
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

      def to_attr_hash
        to_hash # except:remove keys from hash
      end
    end
  end
end
