require 'httparty'

module Api
  module V1
    class LocationsController < ApplicationController
      def fetch_location
        response = HTTParty.get('https://get.geojs.io/v1/ip/geo.json')
        if response.success?
          render json: { location: response.parsed_response }, status: :ok
        else
          render json: { error: 'Failed to fetch location' }, status: :unprocessable_entity
        end
      end
    end
  end
end
