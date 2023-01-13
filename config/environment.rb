# frozen_string_literal: true

require 'figaro'
require 'roda'
require 'sequel'
require 'yaml'
require 'rack/session'
require 'logger'
require 'rack/cache'
require 'redis-rack-cache'

module CafeMap
  # Environment-specific configuration
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    Figaro.env.force_ssl

    # Setup Cacheing mechanism
    configure :development do
      use Rack::Cache,
          verbose: true,
          metastore: 'file:_cache/rack/meta',
          entitystore: 'file:_cache/rack/body'
    end

    configure :production do
      # use Rack::Cache,
      #     verbose: true,
      #     metastore: "#{config.REDISCLOUD_URL}/0/metastore",
      #     entitystore: "#{config.REDISCLOUD_URL}/0/entitystore"
    end

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    configure :app_test do
      require_relative '../spec/helpers/vcr_helper'
      VcrHelper.setup_vcr
      VcrHelper.configure_vcr_for_github(recording: :none)
    end

    # Database Setup
    configure :development, :test, :app_test do
      require 'pry'; # for breakpoints
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
    end

    DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
    # deliberately :reek:UncommunicativeMethodName calling method DB
    def self.DB = DB # rubocop:disable Naming/MethodName

    # Logger Setup
    LOGGER = Logger.new($stderr)
    def self.logger = LOGGER
  end
end
