# frozen_string_literal: true

# test version: do not push
module CafeMap
  module Repository
    # Repository for Info
    class Clusters
      def self.all
        Database::ClusterOrm.all.map { |each| rebuild_entity(each) }
      end

      def self.find(entity)
        find_name(entity.name)
      end

      def self.all_filtered_name(city)
        Database::ClusterOrm.all.select { |each| each.city.include? city }.map(&:name)
      end

      def self.delete_city(_city)
        Database::ClusterOrm.where(city: input).delete
      end

      def self.find_name(name)
        Database::ClusterOrm.first(name:)
      end

      # check if the data has already in db
      def self.create(entity)
        return if find(entity)

        db_cluster = PersistInfo.new(entity).create_cluster
        rebuild_entity(db_cluster)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Cluster.new(
          infoid: db_record.infoid,
          name: db_record.name,
          city: db_record.city,
          wifi: db_record.wifi,
          seat: db_record.seat,
          quiet: db_record.quiet,
          tasty: db_record.tasty,
          cheap: db_record.cheap,
          music: db_record.music,
          url: db_record.url,
          address: db_record.address,
          latitude: db_record.latitude,
          longitude: db_record.longitude,
          limited_time: db_record.limited_time,
          socket: db_record.socket,
          standing_desk: db_record.standing_desk,
          mrt: db_record.mrt,
          open_time: db_record.open_time,
          place_id: db_record.place_id,
          formatted_address: db_record.formatted_address,
          business_status: db_record.business_status,
          location_lat: db_record.location_lat,
          location_lng: db_record.location_lng,
          viewport_ne_lat: db_record.viewport_ne_lat,
          viewport_ne_lng: db_record.viewport_ne_lng,
          viewport_sw_lat: db_record.viewport_sw_lat,
          viewport_sw_lng: db_record.viewport_sw_lng,
          rating: db_record.rating,
          user_ratings_total: db_record.user_ratings_total,
          compound_code: db_record.compound_code,
          global_code: db_record.global_code,
          types: db_record.types,
          cluster: db_record.cluster
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Clusters.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        Database::ClusterOrm.find_or_create(entity.to_attr_hash)
      end
    end

    class PersistInfo
      def initialize(entity)
        @entity = entity
      end

      def create_cluster
        Database::ClusterOrm.create(@entity.to_attr_hash)
      end
    end
  end
end
