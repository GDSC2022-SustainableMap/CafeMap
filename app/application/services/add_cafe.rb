# frozen_string_literal: true

require 'dry/transaction'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class AddCafe
      include Dry::Transaction

      step :validate_city
      step :get_info
      step :check_unrecorded
      step :store_info
      step :get_info_from_db

      private

      GET_UNREC_ERR_MSG = 'Something wrong happened when getting unrecorded info'
      DB_ERR_MSG = 'Something wrong happened when building db'
      DB_ERR = 'There is something in database.'

      def validate_city(input)
        input = input.dup
        city_request = input[:city_request].call
        if city_request.success?
          Success(input.merge(city: city_request.value!))
        else
          Failure(city_request.failure)
        end
      end

      def get_info(input)
        if (filtered_cafe = cafe_from_cafenomad(input))
          Success(input.merge(filtered_infos_data: filtered_cafe))
        end
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :cannot_connect_db, message: e.to_s))
      end

      def check_unrecorded(input)
        lock = 1
        if (info = input[:filtered_infos_data][0..lock])
          info_allname = Repository::For.klass(Entity::Info).all_name
          Success(input.merge(info_unrecorded: info.reject { |each_info| info_allname.include? each_info.name }))
        end
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: GET_UNREC_ERR_MSG))
      end

      def store_info(input)
        info_unrecorded = input[:info_unrecorded] # Entity Array
        city_english = info_unrecorded[0].city
        info_unrecorded.each do |each_unrecorded|
          # Representer::Info.new(each_unrecorded).to_json
          place_entity = CafeMap::Place::StoreMapper.new(App.config.PLACE_TOKEN,
                                                         [each_unrecorded.name]).load_several
          connect_database(place_entity[0]).create(place_entity[0], each_unrecorded.name)
          connect_database(each_unrecorded).create(each_unrecorded)
          last_infoid = connect_database(each_unrecorded).last_id
          last_store = connect_database(place_entity[0]).last
          last_store.update(info_id: last_infoid)
          # Representer::Cafe.new(last_store).to_json
        end
        Success(input.merge(city_eg: city_english))
      rescue StandardError
        Failure(
          Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG)
        )
      end

      def get_info_from_db(input)
        info_from_db = CafeMap::Database::InfoOrm.where(city: input[:city_eg]).all
        store_from_db = CafeMap::Database::InfoOrm.where(city: input[:city_eg]).map { |x| x.store[0] }
        CafeMap::Response::CafeList.new(info_from_db, store_from_db)
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      # Support methods for steps

      def cafe_from_cafenomad(input)
        infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
        infos_data.select { |filter| filter.address.include? input[:city] }.shuffle
      rescue StandardError => e
        raise "Could not find that city on CafeNomad #{e}"
      end

      def connect_database(entity)
        Repository::For.entity(entity)
      end
    end
  end
end
