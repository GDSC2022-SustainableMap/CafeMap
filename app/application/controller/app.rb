# frozen_string_literal: true

# # frozen_string_literal: true

require 'roda'

module CafeMap
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :common_logger, $stderr
    plugin :status_handler
    plugin :caching
    # use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    route do |routing|
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        message = "CafeMap api/v1 at /root/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message:)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end
      routing.on 'api/v1' do
        routing.on 'cafemap' do
          routing.on 'random_store' do
            # post api/v1/cafemap/random_store?city={city}

            routing.post do
              puts "api/v1/cafemap/random_store/#{routing.params}\n"
              city_req = Request::EncodedCityName.new(routing.params)
              filtered_cafelist = Service::AddCafe.new.call(city_request: city_req)
              if filtered_cafelist.failure?
                failed = Representer::HttpResponse.new(filtered_cafelist.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(filtered_cafelist.value!)
              response.status = http_response.http_status_code
              puts filtered_cafelist.value!.message
              Representer::CafeList.new(filtered_cafelist.value!.message).to_json
            end
          end
          # get api/v1/cafemap/clusters?city={city}
          routing.on 'clusters' do
            routing.is do
              routing.get do
                request_id = [request.env, request.path, Time.now.to_f].hash

                # response.cache_control public: true, max_age: 600
                city_request = Request::EncodedCityName.new(routing.params)
                cluster_result = Service::Clustering.new.call(city_request:, request_id:)

                if cluster_result.failure?
                  failed = Representer::HttpResponse.new(cluster_result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(cluster_result.value!)
                response.status = http_response.http_status_code
                Representer::ClusterList.new(cluster_result.value!.message).to_json
              end
            end
          end
          routing.is do
            # Get /api/v1/cafemap?city={city}
            routing.get do
              # response.cache_control public: true, max_age: 30
              filtered_cafelist = Service::MiningCafeList.new.call(routing.params)
              if filtered_cafelist.failure?
                failed = Representer::HttpResponse.new(filtered_cafelist.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(filtered_cafelist.value!)
              response.status = http_response.http_status_code
              Representer::CafeList.new(filtered_cafelist.value!.message).to_json
            end
          end
        end
      end
    end
  end
end
