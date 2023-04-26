module Api
  module V1
    class UsersController < ApplicationController
      before_action :initialize_services
      #@todo: change parts of info function
      def info
        response = { message: nil, status: :ok }
        begin
          response[:message] = @user_service.build_user_response
        rescue StandardError => e
          response = { message: e, status: :internal_server_error }
        end
        render json: response[:message], status: response[:status]
      end

      def destroy
        response = { status_code: :ok, message: nil }
        begin
          city_id = params[:city_id]
          if @user.cities_ids.include?(city_id)
            @user_service.delete_city(@user, city_id)
          else
            { status_code: :bad_request, message: { error: 'city_id_not_found' } }
          end
        rescue StandardError => e
          response = { status_code: :internal_server_error, message: { error: e } }
        end
        render json: response[:message], status: response[:status_code]
      end

      def order
        response = { status_code: :ok, message: nil }
        begin
          valid_params?(%i[cities_ids])
          @user_service.change_order_cities(params[:cities_ids], @user)
        rescue StandardError => e
          response = { status_code: :internal_server_error, message: { error: e } }
        end
        render json: response[:message], status: response[:status_code]
      end

      def add
        begin
          @user_service.add_city(@user, @city_service.fetch_city(params))

          response = { message: nil,
                       status_code: :created }
        rescue StandardError => e
          response = { status_code: :internal_server_error, message: { error: e } }
        end
        render json: response[:message], status: response[:status_code]
      end

      private

      def permitted_params
        params.permit(:device_id)
      end

      def initialize_services
        @user_service = UsersService.new
        @city_service = CitiesService.new
      end
    end
  end
end
