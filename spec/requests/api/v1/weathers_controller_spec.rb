# frozen_string_literal: true

require 'rails_helper'

# RSpec.describe 'Weather_Spec' do
RSpec.describe Api::V1::WeathersController do
  before do
    VCR.use_cassette('Weather JSON') do
      get '/api/v1/weather'
    end
  end

  context 'when success' do
    it 'return http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
