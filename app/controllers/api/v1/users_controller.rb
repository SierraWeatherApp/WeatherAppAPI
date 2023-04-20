module Api
  module V1
    class UsersController < ApplicationController
      def create
        response = { message: nil, status: :created }
        begin
          valid_params?(%i[device_id])
          User.create!(device_id: permitted_params[:device_id])
        rescue Errors::MissingArgumentError => e
          response = { message: e, status: :bad_request }
        rescue StandardError => e
          response = { message: e, status: :internal_server_error }
        end
        render json: response[:message], status: response[:status]
      end

      def show
        response = { message: nil, status: :ok }
        begin
          user = User.find(permitted_params[:id])
          response[:message] = build_user_response(user)
        rescue Errors::RecordNotFound => e
          response = { message: e, status: :bad_request }
        rescue StandardError => e
          response = { message: e, status: :internal_server_error }
        end
        render json: response[:message], status: response[:status]
      end

      private

      def build_user_response(user)
        { user_id: user.id }
      end

      def permitted_params
        params.permit(:device_id, :id)
      end

      def initialize_services
        @user_service = User
      end
    end
  end
end
