require 'uri'
require 'httparty'
require 'openssl'

module Api
  module V1
    class WeathersController < ApplicationController
      def initialize
        super
        initialize_services
      end

      def get_value
        # url = 'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true&timezone=UTC'
        # uri = URI(url)
        # response = Net::HTTP.get(uri)
        latitude = 52.52
        longitude = 13.41
        # url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&current_weather=true&timezone=UTC"
        # uri = URI(url)
        # response = Net::HTTP.get(uri)
        # byebug
        begin
          response = @ws.current_weather(latitude, longitude)
          byebug
          # if valid_params?(%i[latitude longitude temperature_2m])
          #   # response = @ws.current_weather(params[:latitude], params[:longitude])
          #   # response = @ws.request_temperature(params[:temperature_2m])
          # end
        rescue Errors::MissingArgumentError => e
          byebug
          response = { message: e, status: :bad_request }
        end
        render json: response
      end

      private

      def initialize_services
        @ws = WeathersServices.new
      end
    end
  end
end


# module Api
#   module V1
#     class WeathersController < ApplicationController
#       def get_value
#         url = 'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m'
#         uri = URI(url)
#         response = Net::HTTP.get(uri)
#         @ws.send_temperature(response)
#         render json: response
#       end
#     end
#   end
#
#   private
#   def initialize_services
#     @ws = WeathersServices.new
#   end
# end
