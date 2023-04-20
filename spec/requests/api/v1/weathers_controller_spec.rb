# frozen_string_literal: true

require 'rails_helper'

# RSpec.describe 'Weather_Spec' do
RSpec.describe Api::V1::WeathersController do
  before do
    get '/api/v1/weather'
  end

  context 'when success' do
    it 'return http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
