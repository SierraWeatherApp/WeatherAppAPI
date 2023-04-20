# frozen_string_literal: true

require 'json'
class WeathersServices
  # def create_service
  #
  # end
  # 52.52
  # 13.41
  def current_weather(latitude, longitude)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&current_weather=true&timezone=UTC"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    # byebug
    # request_temperature(response)
    # byebug
    # request_wind_speed(response)
    # byebug
    # request_weather_code(response)
    response
  end

  def request_temperature(response)
    data_json = JSON.parse(response)
    data_json['temperature']
  end

  def request_weather_code(response)
    data_json = JSON.parse(response)
    data_json['weathercode']
  end

  def request_wind_speed(response)
    data_json = JSON.parse(response)
    data_json['windspeed']
  end

end
