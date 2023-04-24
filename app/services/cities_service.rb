class CitiesService
  def create_city(user, city_params)
    cities = City.filter_by_user(user)
    City.create!(city_id: city_params[:city_id],
                 city_name: city_params[:city_name],
                 country: city_params[:country],
                 latitude: city_params[:latitude],
                 longitude: city_params[:longitude],
                 order: cities.length + 1,
                 user_id: user.id)
  end

  def delete_city(city)
    city.destroy
  end

  def change_order_cities(params, user)
    cities = params[:cities]
    user_cities_length = City.filter_by_user(user).length
    i = 1
    cities.each do |city|
      change_order_city(city[:id], user_cities_length + i)
    end
    cities.each do |city|
      change_order_city(city[:id], city[:order])
    end
  end

  def change_order_city(id, order)
    city = City.find(id)
    city.update(order:)
  end

  def sort_cities_by_order(cities)
    cities.sort_by(&:order)
  end
end
