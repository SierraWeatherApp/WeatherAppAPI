# frozen_string_literal: true

require 'rails_helper'

# RSpec.describe 'Weather_Spec' do
RSpec.describe Api::V1::WeathersController do
  let(:user) { create(:user, device_id: '19238723y7dh3su2as21dfs231a213sd2af') }

  before do
    get '/api/v1/weather?latitude=52.52&longitude=13.41&temperature=true&weathercode=true&windspeed=true&mode=cw',
        headers: { 'x-device-id' => user.device_id } # &apparent_temperature=true&relativehumidity_2m=true
    # get '/api/v1/weather?latitude=52.52&longitude=13.41&weathercode=true&day=7&temperature_2m_max=true&mode=tf',
    #     headers: { 'x-device-id' => user.device_id }
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

    it 'returns humidity to be nil' do
      expect(JSON.parse(response.body)['relativehumidity_2m']).to be_nil
    end

    it 'returns is_day to be nil' do
      expect(JSON.parse(response.body)['is_day']).to be_nil
    end

    # it 'returns apparent temperature' do
    #   expect(JSON.parse(response.body)['apparent_temperature']).to be_a(Float)
    # end
    #
    # it 'returns max temperature for days' do
    #   expect(JSON.parse(response.body)['temperature_2m_max']).not_to be_nil
    # end
    #
    # it 'returns min temperature for days' do
    #   expect(JSON.parse(response.body)['temperature_2m_min']).to be_nil
    # end
  end
end
