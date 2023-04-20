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

      private

      def permitted_params
        params.permit(:device_id)
      end

      def valid_params?(parameters = [])
        parameters.each do |param|
          raise Errors::MissingArgumentError, param unless params[param]
        end
      end
    end
  end
end
