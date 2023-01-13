# frozen_string_literal: true

require_relative '../../domain/clustering/runner/k_means_main'
require 'dry/transaction'
require 'json'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class Clustering
      include Dry::Transaction

      step :validate_city
      step :check_cluster_db
      step :do_cluster
      step :get_cluster_output
      DB_ERR = 'There is something in database.'
      PROCESSING_MSG = 'Processing the summary request'
      CLUSTER_ERR = 'There is something wrong when clustering.'
      CLUSTER_DB_ERR = 'There is something in cluster dB.'
      def validate_city(input)
        city_request = input[:city_request].call
        if city_request.success?
          Success(input.merge(city: city_request.value!))
        else
          Failure(city_request.failure)
        end
      end

      def check_cluster_db(input)
        input[:city_en] = city_ch_to_en(input[:city])
        if (cluster_db = CafeMap::Database::ClusterOrm.where(city: input[:city_en]).all)
          Success(input.merge(cluster_db:))
        end
      rescue StandardError => e
        puts e
        Failure(Response::ApiResult.new(status: :internal_error, message: CLUSTER_DB_ERR))
      end

      def do_cluster(input)
        puts cluster_request_json(input)
        return Success(input) if check_new_data_in_infoDB?(input)

        Messaging::Queue.new(App.config.CLUSTER_QUEUE_URL, App.config)
          .send(cluster_request_json(input))

        Failure(Response::ApiResult.new(
                  status: :processing,
                  message: { request_id: input[:request_id], msg: PROCESSING_MSG }
                ))
      rescue StandardError => e
        puts e
        Failure(Response::ApiResult.new(status: :internal_error, message: CLUSTER_ERR))
      end

      def get_cluster_output(input)
        CafeMap::Response::ClusterList.new(input[:cluster_db])
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      private

      def city_ch_to_en(input)
        infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
        infos_data.select { |filter| filter.address.include? input }.sample.city
      end

      def check_new_data_in_infoDB?(input)
        info_db_len = CafeMap::Database::InfoOrm.where(city: input[:city_en]).all.length
        cluster_db_len = CafeMap::Database::ClusterOrm.where(city: input[:city_en]).all.length
        info_db_len == cluster_db_len
      end

      def cluster_request_json(input)
        Response::ClusterRequest.new(input[:city], input[:request_id])
          .then { Representer::ClusterRequest.new(_1) }
          .then(&:to_json)
      end
    end
  end
end
