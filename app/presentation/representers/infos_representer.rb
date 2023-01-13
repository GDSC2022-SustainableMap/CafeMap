# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'info_representer'

module CafeMap
  module Representer
    # Represents list of projects for API output
    class InfosList < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      collection :infos, extend: Representer::Info,
                         class: OpenStruct
    end
  end
end
