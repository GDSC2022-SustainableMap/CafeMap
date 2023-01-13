# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'Appraise Info Service (CafeNomad) Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_cafe(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Mining_cafelist (CafeNomad & PlaceAPI)' do
    before do
      DatabaseHelper.wipe_database
      @bad = { 'city'=> '京都' }
      @good = { 'city'=> '新竹' }
    end

    it 'HAPPY: should mine for a api call of an given cafenomad info data' do
      # GIVEN: a valid project that exists locally
      city_request = CafeMap::Request::EncodedCityName.new(@good)
      result = CafeMap::Service::MiningCafeList.new.call(city_request:)
      _(result.success?).must_equal true
    end

    it 'SAD: should not give contributions for non-existent project' do
      # GIVEN: no project exists locally
      city_request = CafeMap::Request::EncodedCityName.new(@bad)
      result = CafeMap::Service::MiningCafeList.new.call(city_request:)

      # Must success cuz it's implement SQL
      _(result.failure?).must_equal false

      # Check the detail in DB
      info_from_db = CafeMap::Database::InfoOrm.where(city: @bad[:city])
      store_from_db = info_from_db.map { |x| x.store[0] }
      info_store = [info_from_db, store_from_db]
      _(info_store[1]).must_equal []
      _(info_store[0]).must_be_instance_of Sequel::SQLite::Dataset
    end
  end
end
