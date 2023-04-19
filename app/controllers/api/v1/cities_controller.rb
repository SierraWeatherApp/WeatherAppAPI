module Api
    module V1 
        class CitiesController < ApplicationController
            def create
                #user = User.find_by(user_id: @current_user.id)
                begin
                    citiesService = CitiesService.new()
                    city = citiesService.create_city(params)
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
                    citiesService = CitiesService.new()
                    citiesService.delete_city(city)
                rescue => exception
                    response = {status_code: :internal_server_error, message: { error: exception } }
                end
                response
            end
            def city_order 
                response= {status_code: :ok, message: nil}
                begin 
                    citiesService = CitiesService.new()
                    citiesService.change_order_city(params)
                rescue => exception
                    response = {status_code: :internal_server_error, message: { error: exception } }
                end
                response
            end
        end
    end
end