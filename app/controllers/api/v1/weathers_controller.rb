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
          if params[:mode] == 'cw' # cw -> current_weather
            jsonresponse = @ws.retrieve_current_weather(params)
          elsif params[:mode] == 'tf' # tf -> time_frame
            valid_params?(%i[day])
            jsonresponse = @ws.retrieve_time_frame(params)
          end
        rescue StandardError => e
          response = { status: :internal_server_error, message: e }
        end
        response[:message] = jsonresponse
        render json: response[:message], status: response[:status]
      end

      private

      def initialize_services
        @ws = WeathersService.new
      end
    end
  end
end
