# frozen_string_literal: true

require 'sequel'
require './config/environment'

module CafeMap
  module Database
    # Object-Relational Mapper for Members
    class ClusterOrm < Sequel::Model(:cluster)
      plugin :timestamps, update_on_create: true
    end
  end
end
