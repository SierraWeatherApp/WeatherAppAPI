class CitiesService
    def create_city(user, city_params)
        cities = City.filter_by_user(user)
        city = City.create!(city_id: city_params[:city_id], 
            city_name: city_params[:city_name], 
            country: city_params[:country], 
            latitude: city_params[:latitude], 
            longitude: city_params[:longitude],
            order: cities.length + 1,
            user_id: user.id
        )
    end
    def delete_city(city)
        begin 
            city.destroy
            rescue => exception
                raise exception
        end
    end
    def change_order_cities(params)
        cities = params[:cities]
        cities.each do |city| 
            change_order_city(city[:id], city[:order]) 
        end
    end
    def change_order_city(id, order)
        city = City.find(id)
        city.update(order: order)
    end
    def sort_cities_by_order(cities)
        cities.sort_by{|city| city.order}
    end
end