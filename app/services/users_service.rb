class UsersService
  def delete_city(user, city_id)
    user.cities_ids.delete(city_id)
    user.update!(cities_ids: user.cities_ids)
  end

  def change_order_cities(cities_ids, user)
    #@todo: finish this bug
    cities_ids = cities_ids.map(&:to_i)
    raise Errors::FlawedOrderError, 'added or missing id' unless user.cities_ids.length == cities_ids.length
    raise Errors::FlawedOrderError, 'duplicate id' unless user.cities_ids.length == cities_ids.uniq.length

    cities_ids.each do |id|
      raise Errors::FlawedOrderError, 'flawed order of cities' unless user.cities_ids.include?(id)
    end
    user.update!(cities_ids:)
  end

  def add_city(user, city_id)
    new_cities_ids = user.cities_ids.push(city_id)
    raise Errors::IncorrectAddError, 'the city is already added' unless user.cities_ids.length == new_cities_ids.uniq.length

    user.update!(cities_ids: new_cities_ids)
  end
end
