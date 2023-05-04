module Api
  module V1
    class UsersController < ApplicationController
      before_action :initialize_services
      def info
        response = { message: nil, status: :ok }
        begin
          response[:message] =
            { cities: @weather_service.cities_weather(@user.cities_ids, @user.temp_unit) }
        rescue StandardError => e
          response = { message: e, status: :internal_server_error }
        end
        render json: response[:message], status: response[:status]
      end

      def all
        response = { status_code: :ok, message: nil }
        begin
          response[:message] = { questions: @question_service.questions_answers(@user) }
        rescue StandardError => e
          response = { status_code: :internal_server_error, message: { error: e } }
        end
        render json: response[:message], status: response[:status_code]
      end

      def answers
        response = { status_code: :ok, message: nil }
        begin
          @question_service.modify_answers(@user, params[:questions])
        rescue StandardError => e
          response = { status_code: :internal_server_error, message: { error: e } }
        end
        render json: response[:message], status: response[:status_code]
      end

      def destroy
        response = { status_code: :ok, message: nil }
        begin
          city_id = params[:city_id].to_i
          if @user.cities_ids.include?(city_id)
            @user_service.delete_city(@user, city_id)
          else
            response = { status_code: :bad_request, message: { error: 'city_id_not_found' } }
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
        rescue Errors::FlawedOrderError => e
          response = { status_code: :bad_request, message: { error: e } }
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
        rescue Errors::IncorrectAddError => e
          response = { status_code: :bad_request, message: { error: e } }
        rescue StandardError => e
          response = { status_code: :internal_server_error, message: { error: e } }
        end
        render json: response[:message], status: response[:status_code]
      end

      def update
        begin
          @user.update!(update_params)

          response = { message: nil,
                       status_code: :ok }
        rescue StandardError => e
          response = { status_code: :bad_request, message: { error: e } }
        end
        render json: response[:message], status: response[:status_code]
      end

      private

      def update_params
        params.permit(:temp_unit, :gender, :look)
      end

      def permitted_params
        params.permit(:device_id)
      end

      def initialize_services
        @user_service = UsersService.new
        @city_service = CitiesService.new
        @weather_service = WeathersService.new
        @question_service = QuestionsService.new
      end
    end
  end
end
