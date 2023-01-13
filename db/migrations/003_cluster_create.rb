# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:cluster) do
      primary_key :id
      String      :infoid
      String      :name
      String      :city
      String      :wifi
      String      :seat
      String      :quiet
      String      :tasty
      String      :cheap
      String      :music
      String      :url
      String      :address
      String      :latitude
      String      :longitude
      String      :limited_time
      String      :socket
      String      :standing_desk
      String      :mrt
      String      :open_time
      String      :place_id
      String      :formatted_address
      String      :business_status

      String      :location_lat
      String      :location_lng
      String      :viewport_ne_lat
      String      :viewport_ne_lng
      String      :viewport_sw_lat
      String      :viewport_sw_lng

      String      :compound_code
      String      :global_code

      Float       :rating
      Integer     :user_ratings_total

      String      :types
      String      :cluster

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
