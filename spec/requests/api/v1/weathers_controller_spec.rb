# frozen_string_literal: true

require 'rails_helper'

# RSpec.describe 'Weather_Spec' do
RSpec.describe Api::V1::WeathersController do
  before do
    get '/api/v1/weather?latitude=52.52&longitude=13.41&temperature=true&weathercode=true&windspeed=true' # , params: {}
  end

  context 'when success' do
    it 'return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns temperature' do
      expect(JSON.parse(response.body))['temperature']
    end

    it 'returns weather code' do
      expect(JSON.parse(response.body))['weathercode']
    end

    it 'returns wind speed' do
      expect(JSON.parse(response.body))['windspeed']
    end

    it 'returns humidity' do
      expect(JSON.parse(response.body))['humidity']
    end

    it 'returns is day' do
      expect(JSON.parse(response.body))['is_day']
    end


  end
end
