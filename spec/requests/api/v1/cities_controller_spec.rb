require 'rails_helper'

RSpec.describe 'Cities' do
  let(:user) { create(:user, device_id: '19238723y7dh3su2as21dfs231a213sd2af') }

  describe 'GET /city' do
    let(:city) do
      create(:city, weather_id: 2_673_730, name: 'Stockholm',
                    country: 'Sweden', latitude: 59.33459, longitude: 18.06324)
    end

    before do
      get "/api/v1/cities/#{city.id}?temperature=true&weathercode=true&windspeed=true&is_day=true",
          headers: { 'x-device-id' => user.device_id }
    end

    it 'returns an ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns city weather id' do
      expect(JSON.parse(response.body)['weather_id']).to eq(city.weather_id)
    end

    it 'returns id' do
      expect(JSON.parse(response.body)['id']).to eq(city.id)
    end
  end
end
