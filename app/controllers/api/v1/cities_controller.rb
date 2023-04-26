module Api
  module V1
    class CitiesController < ApplicationController
      before_action :initialize_services
      #@todo: change function show
      def show
        response = { status_code: :ok, message: nil }
        city = City.find(params[:id])
        if city
          response[:message] = city_response(city)
        else
          response = { status_code: :bad_request, message: { error: 'record_not_found' } }
        end
        render json: response[:message], status: response[:status_code]
      end

      def city_response(city)
        { id: city.id, weather_id: city.weather_id,
          longitude: city.longitude, latitude: city.latitude,
          name: city.name, country: city.country }
      end

      private

      def initialize_services
        @city_service = CitiesService.new
      end
    end
  end
end
