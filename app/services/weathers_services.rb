# frozen_string_literal: true

require 'json'
class WeathersService
  # rubocop:disable Metrics/AbcSize
  def retrieve_values(params)
    jsonresponse = {}
    data_json = JSON.parse(current_weather(params[:latitude], params[:longitude]))
    keys = %i[temperature weathercode windspeed is_day]
    keys.each do |key|
      byebug
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

  def current_weather(latitude, longitude)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=relativehumidity_2m&current_weather=true&forecast_days=1&windspeed_unit=ms"
    uri = URI(url)
    Net::HTTP.get(uri)
  end

  def cities_weather(cities_ids, weather_params)
    cities_ids.each do |id|
      city = City.find(id)
      params = { longitude: city.longitude, latitude: city.latitude }.merge(weather_params)
      weather = retrieve_values(params)
      byebug
      city_response_message(city, weather)
    end
  end

  private

  def city_response_message(city, city_weather)
    {
      city_id: city.id, weather: city_weather, city_name: city.name, longitude: city.longitude, latitude: city.latitude
    }
  end
end
