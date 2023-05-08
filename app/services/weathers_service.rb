# frozen_string_literal: true

require 'json'
class WeathersService
  def retrieve_current_weather(params, temp_unit)
    json_response = {}
    data_json = JSON.parse(current_weather(params[:latitude], params[:longitude], temp_unit))
    keys = %i[temperature weathercode windspeed is_day]
    keys.each do |key|
      json_response = json_response.merge({ key => data_json['current_weather'][key.to_s] })
    end
    keys2 = %i[relativehumidity_2m apparent_temperature precipitation_probability direct_radiation]
    keys2.each do |key2|
      json_response = json_response.merge({ key2 => data_json['hourly'][key2.to_s][Time.now.hour] })
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

  def current_weather(latitude, longitude, temp_unit)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=relativehumidity_2m&hourly=temperature_2m&hourly=precipitation_probability&hourly=direct_radiation&hourly=apparent_temperature&current_weather=true&forecast_days=1&windspeed_unit=ms&temperature_unit=#{temp_unit}"
    uri = URI(url)
    Net::HTTP.get(uri)
  end

  def weather_time_frame(latitude, longitude, day = 1)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&time&daily=temperature_2m_max&daily=temperature_2m_min&forecast_days=#{day}&daily=weathercode&timezone=GMT"
    uri = URI(url)
    Net::HTTP.get(uri)
  end

  def retrieve_cloths_recommendation(weather_params, user_answers)
    JSON.parse(cloths_communication(weather_params, user_answers))
  end

  def cloths_communication(weather_params, user_answers)
    url = "http://130.229.151.193:4444/rec?inputs=#{weather_params[:apparent_temperature]}&inputs=#{weather_params[:temperature]}&inputs=#{weather_params[:relativehumidity_2m]}&inputs=#{weather_params[:windspeed]}&inputs=#{weather_params[:precipitation_probability]}&inputs=#{weather_params[:direct_radiation]}&inputs=#{user_answers['sandalUser']}&inputs=#{user_answers['shortUser']}&inputs=#{user_answers['capUser']}&inputs=#{user_answers['userPlace']}&inputs=#{user_answers['userTemp']}"
    uri = URI(url)
    Net::HTTP.get(uri)
  end

  def cities_weather(cities_ids, temp_unit, user_answers)
    cities_ids.map do |id|
      city_response_message(id, temp_unit, user_answers)
    end
  end

  def city_response_message(id, temp_unit, user_answers)
    city = City.find(id)
    params = { longitude: city.longitude, latitude: city.latitude }
    city_weather = retrieve_current_weather(params, temp_unit)
    cloths_recommendation = retrieve_cloths_recommendation(city_weather, user_answers)
    {
      id: city.id, weather_id: city.weather_id, weather: city_weather, city_name: city.name,
      longitude: city.longitude, latitude: city.latitude, recommendation: cloths_recommendation
    }
  end
end
