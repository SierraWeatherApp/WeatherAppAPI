# frozen_string_literal: true

require 'json'
class WeathersServices
  # def create_service
  #
  # end
  # 52.52
  # 13.41
  def current_weather(latitude, longitude)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=relativehumidity_2m&current_weather=true&forecast_days=1"
    uri = URI(url)
    response = Net::HTTP.get(uri)
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

  def request_humidity(response)
    data_json = JSON.parse(response)
    data_json['relativehumidity_2m'][0]
  end

  def request_day_status(response)
    data_json = JSON.parse(response)
    data_json['is_day']
  end

end
