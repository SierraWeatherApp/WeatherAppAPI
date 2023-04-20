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

      def current_weather
        response = { status: :ok, message: nil }
        begin
          valid_params?(%i[latitude longitude])
          jsonresponse = @ws.retrieve_values(params)
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