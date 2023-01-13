# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Add_Cade Service Integration Test' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_cafe(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve cafe shop info success or not' do
    before do
      DatabaseHelper.wipe_database
      city_request = CafeMap::Request::EncodedCityName.new({ 'city'=> '新竹' })
      @city_assign = city_request.uncode_cityname
      @store_made = CafeMap::Service::AddCafe.new.call(city_request:)
      @hash = eval(CafeMap::Representer::CafeList.new(@store_made.value!.message).to_json)
    end

    it 'HAPPY: should be able to find and save remote data into to db' do
      _(@store_made.success?).must_equal true
      _(@store_made.nil?).must_equal false
      _(@store_made.frozen?).must_equal false
    end

    it 'Both retrieve data from different API need to build the relation successfully' do
      info_hash = @hash[:infos]
      stores_hash = @hash[:stores]
      _(info_hash.length).must_equal stores_hash.length
      ### infoid & name can not be nil
      info_hash.map { |row| row[:infoid] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:name] }.all? { |element| _(element).must_be_instance_of String }
    end

    it 'CITY_CHECK: The retrieve data comes from Cafenomad must comes from the specific city' do
      info_hash = @hash[:infos]
      info_hash.map { |row| row[:address] }.all? { |element| _(element).must_include @city_assign }
      info_hash.map { |row| row[:city] }.all? { |element| _(element).must_include @city_assign }
    end

    it 'CITY_CHECK: The retrieve data comes from PlaceAPI must comes from the specific city' do
      info_hash = @hash[:stores]
      info_hash.map { |row| row[:compound_code] }.all? { |element| _(element).must_include @city_assign }
    end

    it 'SCHEMA_CHECK: All the rating from CafeNomad have to be STRING' do
      info_hash = @hash[:infos]

      info_hash.map { |row| row[:wifi] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:seat] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:music] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:cheap] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:tasty] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:quiet] }.all? { |element| _(element).must_be_instance_of String }
    end

    it 'SCHEMA_CHECK: All the rating from CafeNomad have to be STRING' do
      info_hash = @hash[:infos]
      info_hash.map { |row| row[:wifi] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:seat] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:music] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:cheap] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:tasty] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:quiet] }.all? { |element| _(element).must_be_instance_of String }
    end

    it 'SCHEMA_CHECK: All the rating from PlaceAPI' do
      store_hash = @hash[:stores]
      store_hash.map { |row| row[:rating] }.all? { |element| _(element).must_be_instance_of Integer }
      store_hash.map { |row| row[:user_ratings_total] }.all? { |element| _(element).must_be_instance_of Integer }
    end
  end
end
