class CitiesService
    def create_city(city_params)
        city = City.create(city_id: city_params[:city_id], 
            city_name: city_params[:city_name], 
            country: city_params[:country], 
            latitude: city_params[:latitude], 
            longitude: city_params[:longitude],
            order: 0
        )
    end
    def delete_city(city)
        begin 
            city.destroy
            rescue => exception
                raise exception
        end
    end
    def change_order_city(params)
        
    end
end