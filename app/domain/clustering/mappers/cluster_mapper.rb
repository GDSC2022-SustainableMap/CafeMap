# frozen_string_literal: false

require_relative '../entities/cluster'
require_relative 'mixin_module'

module CafeMap
  module Cluster
    # InfoMapper is the mapper deal with CafeNomad API
    class ClusterMapper
      # tokename will be "Cafe_api"
      def initialize(data)
        @data = data
      end

      attr_reader :data

      def load_several
        @data.map do |each_cluster|
          ClusterMapper.build_entity(each_cluster)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end
    end

    # Map the data comes from gateway into entity
    class DataMapper
      include ClusterMixinRank
      include ClusterMixinGeo
      def initialize(data)
        @data = data
      end

      def build_entity
        Entity::Cluster.new(
          infoid:,
          name:,
          city:,
          wifi:,
          seat:,
          quiet:,
          tasty:,
          cheap:,
          music:,
          url:,
          address:,
          latitude:,
          longitude:,
          limited_time:,
          socket:,
          standing_desk:,
          mrt:,
          open_time:,
          place_id:,
          # name:,
          formatted_address:,
          business_status:,
          location_lat:,
          location_lng:,
          viewport_ne_lat:,
          viewport_ne_lng:,
          viewport_sw_lat:,
          viewport_sw_lng:,
          compound_code:,
          global_code:,
          rating:,
          user_ratings_total:,
          types:,
          cluster:
        )
      end
    end
  end
end
