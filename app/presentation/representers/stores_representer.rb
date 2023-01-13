# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'store_representer'

module CafeMap
  module Representer
    # Represents list of projects for API output
    class StoresList < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      collection :stores, extend: Representer::Store,
                          class: OpenStruct
    end
  end
end
