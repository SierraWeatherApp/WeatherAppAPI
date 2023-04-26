class UsersService
  def build_user_response
    city = City.all.first
    { name: city.name, country: city.country, latitude: city.latitude,
      longitude: city.longitude, weather_id: city.weather_id,
      id: city.id }
  end

  def delete_city(user, city_id)
    update!(cities_ids: user.cities_ids.delete(city_id))
  end

  def change_order_cities(cities_ids, user)
    user.update!(cities_ids:)
  end

  def add_city(user, city_id)
    user.update!(cities_ids: user.cities_ids.push(city_id))
  end

  private

  def city_response_message(city, city_weather)
    {
      city_id: city.id, humidity: city_weather[:humidity], wind: city_weather[:wind],
      city_name: city.name, weather: city_weather[:weather], longitude: city.longitude, latitude: city.latitude
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
