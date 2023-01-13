# frozen_string_literal: true

require_relative '../require_app'
require_app
require_relative 'cluster_monitor'
require_relative 'job_reporter'

require 'figaro'
require 'shoryuken'
require_relative './../app/domain/clustering/runner/k_means_main'

# Shoryuken worker class to clone repos in parallel
module Cluster
  class Worker
    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment: ENV['RACK_ENV'] || 'development',
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    Shoryuken.sqs_client = Aws::SQS::Client.new(
      access_key_id: config.AWS_ACCESS_KEY_ID,
      secret_access_key: config.AWS_SECRET_ACCESS_KEY,
      region: config.AWS_REGION
    )

    include Shoryuken::Worker
    shoryuken_options queue: config.CLUSTER_QUEUE_URL, auto_delete: true

    def perform(_sqs_msg, request)
      job = JobReporter.new(request, Worker.config) # {city:彰化, id: hash value}
      job.report(ClusterMonitor.starting_percent)
      CafeMap::CityCluster.new(job.city).cluster do |line|
        job.report ClusterMonitor.progress(line)
      end
      job.report_each_second(5) { ClusterMonitor.finished_percent }
    rescue StandardError
      puts 'Cluster EXISTS -- ignoring request'
    end
  end
end
