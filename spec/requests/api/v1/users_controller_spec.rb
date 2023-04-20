require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /create' do
    context 'when create user incorrectly' do
      before do
        post '/api/v1/users'
      end

      it 'returns bad request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when create user correctly' do
      before do
        post '/api/v1/users', params: { device_id: 'ffIFPHk4EUo1tXlQBVQxj:APA91bF8STc2g' }
      end

      it 'returns success status' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
