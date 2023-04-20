require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /info' do
    context 'when user no exist, creates one' do
      let(:device_id) { 'k123v23hj213321jh12kj3123k' }

      before do
        get '/api/v1/user', headers: { 'x-device-id' => device_id }
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'creates user' do
        user = User.find_by(device_id:)
        expect(user.device_id).to eq(device_id)
      end

      it 'returns the main city' do
        expect(JSON.parse(response.body)['city_name']).to eq('Stockholm')
      end
    end

    context 'when device_id is not sent' do
      before do
        get '/api/v1/user'
      end

      it 'returns internal server error status' do
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
