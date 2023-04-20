class UsersService
  def build_user_response(user)
    city = City.all.main_city(user).first
    { city_name: city.city_name, country: city.country, latitude: city.latitude,
      longitude: city.longitude, order: city.order, city_weather_id: city.city_id, id: city.id }
  end

  private

  def city_response_message(city, city_weather)
    {
      city_id: city.id, humidity: city_weather[:humidity], wind: city_weather[:wind],
      city_name: city.city_name, weather: city_weather[:weather], longitude: city.longitude, latitude: city.latitude
    }
  end

  def city_list_response_message(cities)
    cities_weather = obtain_cities_weather(cities)
    cities.map do |city|
      city_weather = cities_weather[city.city_id]
      city_response_message(city, city_weather)
    end
  end

  def obtain_cities_weather(cities)
    # TODO: get cities weather with the weather service
  end
end
