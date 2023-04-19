require 'uri'
require 'httparty'
require 'openssl'

module Api
  module V1
    class WeathersController < ApplicationController
      def get_value
        # @response = WeatherController.all
        # render json: @response, status: @status

        # api_url = 'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m'
        # byebug
        # response = RestClient.get(api_url)
        # render plain: response

        # url = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m"
        # response = HTTParty.get(url).parsed_response
        # render json: response
        url = 'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m'
        uri = URI(url)
        response = Net::HTTP.get(uri)
        byebug
        render json: response
      end
    end
  end
end