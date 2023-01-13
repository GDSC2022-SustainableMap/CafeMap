# frozen_string_literal: true

require 'faye'
require_relative 'require_app'
require_app

use Faye::RackAdapter, mount: '/faye', timeout: 25
run CafeMap::App.freeze.app