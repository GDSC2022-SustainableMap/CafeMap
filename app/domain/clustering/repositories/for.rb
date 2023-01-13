# frozen_string_literal: true

require_relative '../../googleplace/repositories/stores'
require_relative '../../cafenomad/repositories/infos'
require_relative 'clusters'

module CafeMap
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::Store   => Stores,
        Entity::Info    => Infos,
        Entity::Cluster => Clusters
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
