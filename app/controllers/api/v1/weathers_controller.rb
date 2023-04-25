module Api
  module V1
    class WeathersController < ApplicationController
      def initialize
        super
        initialize_services
      end

      def current_weather
        response = { status: :ok, message: nil }
        begin
          valid_params?(%i[latitude longitude day])
          jsonresponse = @ws.retrieve_time_frame(params)
          #jsonresponse = @ws.retrieve_values(params)
        rescue StandardError => e
          response = { status: :internal_server_error, message: e }
        end
        response[:message] = jsonresponse
        render json: response[:message], status: response[:status]
      end

      private

      def initialize_services
        @ws = WeathersServices.new
      end
    end
  end
end
