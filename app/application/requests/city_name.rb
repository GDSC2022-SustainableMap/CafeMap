# frozen_string_literal: true

require 'base64'
require 'dry/monads'
require 'json'

module CafeMap
  module Request
    # Project list request parser
    class EncodedCityName
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        city = @params['city'].force_encoding('UTF-8')
        Success(city)
      rescue StandardError => e
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: "Error: #{e}. Message: Fails to encode the city_name at /request/city_name"
          )
        )
      end

      def uncode_cityname
        @params['city']
      end

    rescue StandardError => e
      Failure(
        Response::ApiResult.new(
          status: :bad_request,
          message: "Error: #{e}. Message: Bad ApiResult at /request/"
        )
      )
    end

    # Decode params
    def candy(param)
      Base64.urlsafe_decode64(param)
    end
    # Can not find where it being call? The frontend acceptance test have to test it
  end
end
