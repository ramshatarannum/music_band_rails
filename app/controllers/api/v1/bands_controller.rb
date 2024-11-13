module Api
  module V1
    class BandsController < ApplicationController
      BASE_URL = 'https://musicbrainz.org/ws/2/artist'.freeze
      TIME_PERIOD = 10.years.ago.year

      before_action :set_cors_headers

       def set_cors_headers
          response.set_header('Access-Control-Allow-Origin', 'http://localhost:4000')
          response.set_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
          response.set_header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept, Authorization, X-Request-With')
       end

      def search
        city = params[:city]
        if city.blank?
          return render json: { error: 'City parameter is required' }, status: :bad_request
        end

        # Search for bands founded in the last 10 years within the specified location
        response = HTTParty.get(
          BASE_URL,
          query: {
            query: "area:#{city} AND begin:[#{TIME_PERIOD} TO *]",
            fmt: 'json',
            limit: 50
          },
          headers: { 'User-Agent' => 'MusicBandSearch/1.0' }
        )

        if response.success?
          bands = response.parsed_response['artists'].map do |artist|
            {
              name: artist['name'],
              founded_year: artist['life-span']&.dig('begin')
            }
          end
          render json: { bands: bands }, status: :ok
        else
          render json: { error: 'Failed to fetch band data' }, status: :unprocessable_entity
        end
      end
    end
  end
end
