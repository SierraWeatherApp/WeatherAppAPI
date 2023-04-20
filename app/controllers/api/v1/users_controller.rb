module Api
  module V1
    class UsersController < ApplicationController
      before_action :initialize_services
      def info
        response = { message: nil, status: :ok }
        begin
          response[:message] = @user_service.build_user_response(@user)
        rescue StandardError => e
          response = { message: e, status: :internal_server_error }
        end
        render json: response[:message], status: response[:status]
      end

      private

      def initialize_services
        @user_service = UserService.new
      end
    end
  end
end
