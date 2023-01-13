# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'


# require 'headless'
require 'webdrivers/chromedriver'
require 'watir'
require 'page-object'
# require 'rspec'

require_relative 'spec_helper'
require_relative 'database_helper'

# RSpec::Matchers.define :be_continuous_and_sequential do
#   match do |actual|
#     # Iterate over the elements in the array and check that each element is
#     # one greater than the previous element:
#     actual.each_cons(2).all? { |a, b| a + 1 == b }
#   end

#   failure_message do |actual|
#     "expected #{actual} to be continuous and sequential"
#   end

#   failure_message_when_negated do |actual|
#     "expected #{actual} not to be continuous and sequential"
#   end
# end
