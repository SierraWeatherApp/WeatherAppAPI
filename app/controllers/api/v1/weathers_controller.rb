module Api
  module V1
    class WeathersController < ApplicationController
      def initialize
        super
        initialize_services
      end

      def weather_info
        response = { status: :ok, message: nil }
        begin
          valid_params?(%i[latitude longitude mode])
          json_response = mode(params)
        rescue StandardError => e
          response = { status: :internal_server_error, message: e }
        end
        response[:message] = json_response
        render json: response[:message], status: response[:status]
      end

      def mode(params)
        if params[:mode] == 'cw' # cw -> current_weather
          @ws.retrieve_current_weather(params, @user.temp_unit)
        elsif params[:mode] == 'tf' # tf -> time_frame
          valid_params?(%i[day])
          @ws.retrieve_time_frame(params)
        else
          @ws.retrieve_forecast(params, @user.temp_unit)
        end
      end

      private

      def initialize_services
        @ws = WeathersService.new
      end
    end
  end
end
