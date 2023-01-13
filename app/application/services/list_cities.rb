# frozen_string_literal: true

require 'dry/monads'

module CafeMap
  module Service
    # Retrieves array of all listed cities entities
    class ListCities
      include Dry::Monads::Result::Mixin
      def call
        cities = Repository::For.klass(Entity::Info).find_all_city
        Success(cities)
      end
    rescue StandardError
      Failure('Sorry: Could not access database based on assigned city')
    end
  end
end
