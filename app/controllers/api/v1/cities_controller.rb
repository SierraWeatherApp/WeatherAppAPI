module Api
    module V1 
        class CitiesController < ApplicationController
            before_action :initialize_services
            def create
                begin
                    user = User.find(params[:user_id])
                    city = @city_service.create_city(user, params)
                    response = { message: nil,
                        status_code: :created } 
                rescue => exception
                    response = {status_code: :internal_server_error, message: { error: exception } }
                end
                render json: response[:message], status: response[:status_code]
            end
            def destroy
                city = City.find(params[:id])
                response = if city
                    destroy_city(city)
                    else
                        {status_code: :bad_request, message:{ error: 'record_not_found' }}
                    end
                render json: response[:message], status: response[:status_code]
            end
            def destroy_city(city)
                response= {status_code: :ok, message: nil}
                begin 
                    @city_service.delete_city(city)
                rescue => exception
                    response = {status_code: :internal_server_error, message: { error: exception } }
                end
                response
            end
            def city_order 
                response= {status_code: :ok, message: nil}
                begin 
                    @city_service.change_order_cities(params)
                rescue => exception
                    response = {status_code: :internal_server_error, message: { error: exception } }
                end
                render json: response[:message], status: response[:status_code]
            end
            def show
                response = {status_code: :ok, message: nil}
                city = City.find(params[:id])
                if city
                    response[:message] = city_response(city)
                else
                    response = { status_code: :bad_request, message: { error: 'record_not_found' } }
                end
                render json: response[:message], status: response[:status_code]
            end
            def index
                response = {status_code: :ok, message: nil}
                user = User.find(params[:user_id])
                cities = City.filter_by_user(user)
                cities = @city_service.sort_cities_by_order(cities)
                response_list = []
                if cities.length > 0
                    cities.each do |city| 
                        response_list << city_response(city)
                    end
                    response[:message] = {cities: response_list}
                else
                    response = { status_code: :bad_request, message: { error: 'record_not_found' } }
                end
                render json: response[:message], status: response[:status_code]
            end
            def city_response(city)
                {id: city.id, city_id: city.city_id, 
                    longitude: city.longitude, latitude: city.latitude, 
                    city_name: city.city_name, country: city.country}
            end

            private

            def initialize_services
                @city_service = CitiesService.new
            end
            
        end
    end
end