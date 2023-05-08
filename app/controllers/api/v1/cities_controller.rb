module Api
  module V1
    class CitiesController < ApplicationController
      before_action :initialize_services
      def show
        response = { status_code: :ok, message: nil }
        city = City.find(params[:id])
        if city
          response[:message] =
            @weather_service.city_response_message(city.id, @user.temp_unit)
        else
          response = { status_code: :bad_request, message: { error: 'record_not_found' } }
        end
        render json: response[:message], status: response[:status_code]
      end

      private

      def weather_params
        params.permit(:temperature, :weathercode, :windspeed, :is_day, :mode)
      end

      def initialize_services
        @weather_service = WeathersService.new
      end
    end
  end
end
