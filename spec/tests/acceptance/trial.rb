require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/acceptance_helper'
require 'cgi'
require 'rack/test'
@input = { 'city'=> '新竹' }

city_request = CafeMap::Request::EncodedCityName.new(@input)
puts "CH City Name: #{city_request.dup.uncode_cityname}"
store_made = CafeMap::Service::AddCafe.new.call(city_request:)
puts "outputs: #{store_made}"
puts "outputs.success: #{store_made.success?}"

url_encoded_string = CGI.escape(city_request.call.value!)
puts "\n\nurl_encoded_string: #{url_encoded_string}"

post "/api/v1/cafemap/random_store?city=#{url_encoded_string}"
    _(last_response.status).must_equal 200
    body = JSON.parse last_response.body
    3.times { sleep(1) and print('.') }