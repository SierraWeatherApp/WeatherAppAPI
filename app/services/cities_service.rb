class CitiesService
  def create_city(city_params)
    City.create!(weather_id: city_params[:weather_id],
                 name: city_params[:name],
                 country: city_params[:country],
                 latitude: city_params[:latitude],
                 longitude: city_params[:longitude])
  end

  def fetch_city(params)
    city = City.find_by(weather_id: params[:weather_id].to_i)
    return city.id unless city.nil?

    city = City.create!(weather_id: params[:weather_id],
                 name: params[:name],
                 country: params[:country],
                 latitude: params[:latitude],
                 longitude: params[:longitude])
    city.id
  end

end
