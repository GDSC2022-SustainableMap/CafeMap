# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential Repo information for API output
module CafeMap
  module Representer
    # Representer object for project clone requests
    class ClusterRequest < Roar::Decorator
      include Roar::JSON

      property :city
      property :id
    end
  end
end
