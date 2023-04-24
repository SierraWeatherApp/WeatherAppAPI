# frozen_string_literal: true

require 'rails_helper'

# RSpec.describe 'Weather_Spec' do
RSpec.describe Api::V1::WeathersController do
  let(:user) { create(:user, device_id: '19238723y7dh3su2as21dfs231a213sd2af') }
  before do
    get '/api/v1/weather?latitude=52.52&longitude=13.41&temperature=true&weathercode=true&windspeed=true' , headers: { 'x-device-id' => user.device_id }
  end

  context 'when success' do
    it 'return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns temperature' do
      expect(JSON.parse(response.body)['temperature']).to be_a(Float)
    end

    it 'returns weather code' do
      expect(JSON.parse(response.body)['weathercode']).to be_a(Integer)
    end

    it 'returns wind speed' do
      expect(JSON.parse(response.body)['windspeed']).to be_a(Float)
    end

    it 'returns humidity' do
      expect(JSON.parse(response.body)['humidity']).to be_nil
    end

    it 'returns is day' do
      expect(JSON.parse(response.body)['is_day']).to be_nil
    end
  end
end
