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
        begin
          jsonresponse = {}
          valid_params?(%i[latitude longitude])
          response_cw = @ws.current_weather(params[:latitude], params[:longitude])

          if params.has_key?(:temperature)
            if params[:temperature] == "true"
              json_temp = {temperature: @ws.request_temperature(response_cw) }
              jsonresponse = jsonresponse.merge(json_temp)
            end
          end
          if params.has_key?(:weathercode)
            if params[:weathercode] == "true"
              json_wc = { weathercode: @ws.request_weather_code(response_cw)}
              jsonresponse = jsonresponse.merge(json_wc)
            end
          end
          if params.has_key?(:windspeed)
            if params[:windspeed] == "true"
              json_ws =  {windspeed: @ws.request_wind_speed(response_cw)}
              jsonresponse = jsonresponse.merge(json_ws)
            end
          end
          if params.has_key?(:relativehumidity_2m)
            if params[:relativehumidity_2m] == "true"
              json_hum[:relativehumidity_2m] =  @ws.request_humidity(response_cw)
              jsonresponse = jsonresponse.merge(json_hum)
            end
          end
          if params.has_key?(:relativehumidity_2m)
            if params[:relativehumidity_2m] == "true"
              json_day[:is_day] =  @ws.request_day_status(response_cw)
              jsonresponse = jsonresponse.merge(json_day)
            end
          end
        byebug
        end
        render jsonresponse
      end

      private

      def initialize_services
        @ws = WeathersServices.new
      end
    end
  end
end
