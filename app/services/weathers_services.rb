# frozen_string_literal: true

require 'json'
class WeathersServices
  def current_weather(latitude, longitude)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=relativehumidity_2m&current_weather=true&forecast_days=1"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    response
  end

  def request_temperature(response)
    data_json = JSON.parse(response)
    data_json['current_weather']['temperature']
  end

  def request_weather_code(response)
    data_json = JSON.parse(response)
    data_json['current_weather']['weathercode']
  end

  def request_wind_speed(response)
    data_json = JSON.parse(response)
    data_json['current_weather']['windspeed']
  end

  def request_day_status(response)
    data_json = JSON.parse(response)
    data_json['current_weather']['is_day']
  end

  def request_humidity(response)
    data_json = JSON.parse(response)
    data_json['relativehumidity_2m'][0]
  end

end
