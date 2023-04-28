# frozen_string_literal: true

require 'json'
class WeathersServices
  # rubocop:disable Metrics/AbcSize
  def retrieve_current_weather(params)
    json_response = {}
    data_json = JSON.parse(current_weather(params[:latitude], params[:longitude]))
    keys1 = %i[temperature weathercode windspeed is_day apparent_temperature]
    keys1.each do |key1|
      if params.key?(key1) && params[key1] == 'true'
        json_response = json_response.merge({ key1 => data_json['current_weather'][key1.to_s] })
      end
    end
    keys2 = %i[relativehumidity_2m apparent_temperature]
    keys2.each do |key2|
      if params.key?(key2) && params[key2] == 'true'
        json_response = json_response.merge({ key2 => data_json['hourly'][key2.to_s][Time.now.hour] })
      end
    end
    json_response
  end

  def retrieve_time_frame(params)
    json_response = {}
    data_json = JSON.parse(weather_time_frame(params[:latitude], params[:longitude], params[:day]))
    keys = %i[temperature_2m_max temperature_2m_min weathercode]
    keys.each do |key|
      if params.key?(key) && params[key] == 'true'
        json_response = json_response.merge({ key => data_json['daily'][key.to_s] })
      end
    end
    json_response
  end
  # rubocop:enable Metrics/AbcSize

  def current_weather(latitude, longitude)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=relativehumidity_2m&hourly=temperature_2m&hourly=apparent_temperature&current_weather=true&forecast_days=1&windspeed_unit=ms"
    uri = URI(url)
    Net::HTTP.get(uri)
  end

  def weather_time_frame(latitude, longitude, day = 1)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&time&daily=temperature_2m_max&daily=temperature_2m_min&forecast_days=#{day}&daily=weathercode&timezone=GMT"
    uri = URI(url)
    Net::HTTP.get(uri)
  end
end
