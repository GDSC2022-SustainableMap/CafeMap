# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'List_Cafe function: Read db based on city' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_cafe(recording: :none)
    city_request = CafeMap::Request::EncodedCityName.new({ 'city'=> '新竹' })
    @city_assign = city_request.uncode_cityname
    @filtered_cafelist = CafeMap::Service::MiningCafeList.new.call(city_request:)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Read DB successful or not' do
    before do
      DatabaseHelper.wipe_database
    end
    it 'Check the access of database is working or not' do
      _(@filtered_cafelist.success?).must_equal true
      _(@filtered_cafelist.empty?).must_equal false
    end
  end
end
