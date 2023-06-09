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

  def retrieve_forecast(params, temp_units)
    json_response = {}
    data_json = JSON.parse(forecast(params[:latitude], params[:longitude], temp_units))
    i_values = []
    (Time.now.hour..(Time.now.hour + 23)).each do |i|
      i_values << i
    end
    keys = %i[temperature_2m weathercode]
    keys.each do |key|
      temp = []
      next unless params.key?(key) && params[key.to_s] == 'true'

      json_response = retrieve_temp_cw(temp, data_json, i_values, json_response, key)
    end
    json_response
  end

  def retrieve_temp_cw(temp, data_json, i_values, json_response, key)
    i_values.each do |i|
      temp.append(data_json['hourly'][key.to_s][i])
    end
    json_response.merge({ key => temp })
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

  def retrieve_cloths_recommendation(weather_params, temperature, apparent_temperature, user_answers)
    JSON.parse(cloths_communication(weather_params, temperature, apparent_temperature, user_answers))
  end

  def cloths_communication(weather_params, temperature, apparent_temperature, user_answers)
    url = "https://limtinsel.onrender.com/rec?inputs=#{apparent_temperature}&inputs=#{temperature}&inputs=#{weather_params[:relativehumidity_2m]}&inputs=#{weather_params[:windspeed]}&inputs=#{weather_params[:precipitation_probability]}&inputs=#{weather_params[:direct_radiation]}&inputs=#{user_answers['sandalUser']}&inputs=#{user_answers['shortUser']}&inputs=#{user_answers['capUser']}&inputs=#{user_answers['userPlace']}&inputs=#{user_answers['userTemp']}"
    uri = URI(url)
    Net::HTTP.get(uri)
  end

  def forecast(latitude, longitude, temp_units)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&time&hourly=weathercode&hourly=temperature_2m&timezone=GMT&temperature_unit=#{temp_units}"
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
    temperature = city_weather[:temperature]
    apparent_temperature = city_weather[:apparent_temperature]
    unless temp_unit == 'celsius'
      temperature, apparent_temperature = convert_to_celsius(city_weather[:temperature],
                                                             city_weather[:apparent_temperature])
    end
    cloths_recommendation = retrieve_cloths_recommendation(city_weather, temperature, apparent_temperature,
                                                           user_answers)
    {
      id: city.id, weather_id: city.weather_id, weather: city_weather, city_name: city.name,
      longitude: city.longitude, latitude: city.latitude, recommendation: cloths_recommendation
    }
  end

  private

  def convert_to_celsius(temperature, apparent_temperature)
    [temperature, apparent_temperature].map { |fahrenheit| celsius_to_fahrenheit(fahrenheit) }
  end

  def celsius_to_fahrenheit(fahrenheit)
    (fahrenheit - 32) * 5 / 9
  end
end
