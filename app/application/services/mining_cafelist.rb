# frozen_string_literal: true

require 'dry/transaction'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class MiningCafeList
      include Dry::Transaction

      step :get_info_from_db

      DB_ERR = 'MiningCafeList Service Error: Error happens in database.'

      def get_info_from_db(input)
        info_from_db = CafeMap::Database::InfoOrm.where(city: input['city'])
        store_from_db = CafeMap::Database::InfoOrm.where(city: input['city']).map { |x| x.store[0] }
        CafeMap::Response::CafeList.new(info_from_db, store_from_db)
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      end
    rescue StandardError
      Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
    end

    def peak(input)
      info_from_db = CafeMap::Database::InfoOrm.where(city: input['city'])
      store_from_db = CafeMap::Database::InfoOrm.where(city: input['city']).map { |x| x.store[0] }
      [info_from_db, store_from_db]
    end
  end
end
