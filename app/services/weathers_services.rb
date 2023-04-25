# frozen_string_literal: true

require 'json'
class WeathersServices
  # rubocop:disable Metrics/AbcSize
  def retrieve_values(params)
    jsonresponse = {}
    data_json = JSON.parse(current_weather(params[:latitude], params[:longitude]))
    keys = %i[temperature weathercode windspeed is_day]
    keys.each do |key|
      if params.key?(key) && params[key] == 'true'
        jsonresponse = jsonresponse.merge({ key => data_json['current_weather'][key.to_s] })
      end
    end
    if params.key?(:relativehumidity_2m) && params[:relativehumidity_2m] == 'true'
      jsonresponse = jsonresponse.merge({ relativehumidity_2m: data_json['relativehumidity_2m'][Time.now.hour] })
    end
    jsonresponse
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def retrieve_time_frame(params)
    response = {}
    data_json = JSON.parse(weather_time_frame(params[:latitude], params[:longitude], params[:day]))
    byebug
    if params.key?(:relativehumidity_2m) && params[:relativehumidity_2m] == 'true'
      response = response.merge({ relativehumidity_2m: data_json['daily']['relativehumidity_2m'] })
    end
    byebug
    if params.key?(:temperature_2m_max) && params[:temperature_2m_max] == 'true'
      response = response.merge({ temperature_2m_max: data_json['daily']['temperature_2m_max']})
    end
    byebug
    if params.key?(:temperature_2m_min) && params[:temperature_2m_min] == 'true'
      response = response.merge({ temperature_2m_min: data_json['daily']['temperature_2m_min']})
    end
    byebug
    if params.key?(:weathercode) && params[:weathercode] == 'true'
      response = response.merge({ weathercode: data_json['daily']['weathercode']})
    end
    byebug
    response
  end
  # rubocop:enable Metrics/AbcSize

  def current_weather(latitude, longitude)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=relativehumidity_2m&hourly=temperature_2m&current_weather=true&forecast_days=1&windspeed_unit=ms"
    uri = URI(url)
    Net::HTTP.get(uri)
  end

  def weather_time_frame(latitude, longitude, day = 1)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&time&daily=temperature_2m_max&daily=temperature_2m_min&forecast_days=#{day}&daily=weathercode&timezone=GMT"
    uri = URI(url)
    Net::HTTP.get(uri)
  end
end
