# frozen_string_literal: true

require_relative 'progress_publisher'

module Cluster
  # Reports job progress to client
  class JobReporter
    def initialize(request_json, config)
      cluster_request = CafeMap::Representer::ClusterRequest
        .new(OpenStruct.new)
        .from_json(request_json)
      @city = cluster_request.city
      @publisher = ProgressPublisher.new(config, cluster_request.id)
    end

    attr_reader :city

    def report(msg)
      @publisher.publish msg
    end

    def report_each_second(seconds, &operation)
      seconds.times do
        sleep(1)
        report(operation.call)
      end
    end
  end
end
