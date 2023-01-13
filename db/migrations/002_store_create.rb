# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:store) do
      primary_key :id
      foreign_key :info_id, :info

      String      :place_id
      String      :name
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

      String :types

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
