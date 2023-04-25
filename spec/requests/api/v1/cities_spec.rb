require 'rails_helper'

RSpec.describe 'Cities' do
  let(:user) { create(:user, device_id: '19238723y7dh3su2as21dfs231a213sd2af') }

  describe 'POST /create' do
    # pending "add some examples (or delete) #{__FILE__}"
    before do
      create(:city, city_id: 2_673_730, city_name: 'Stockholm',
                    country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 1, user_id: user.id)
      create(:city, city_id: 2_673_731, city_name: 'Stockholm',
                    country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 2, user_id: user.id)
      post '/api/v1/user/cities', params: { city_id: 2_673_732, city_name: 'Stockholm', country: 'Sweden',
                                            latitude: 59.33459, longitude: 18.06324 },
                                  headers: { 'x-device-id' => user.device_id }
    end

    it 'returns a created status' do
      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE /destroy' do
    let(:city) do
      create(:city, city_id: 2_673_731, city_name: 'Stockholm',
                    country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 1, user_id: user.id)
    end
    before do
      create(:city, city_id: 2_673_732, city_name: 'Stockholm',
        country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 2, user_id: user.id)
      create(:city, city_id: 2_673_733, city_name: 'Stockholm',
        country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 3, user_id: user.id)
      delete "/api/v1/user/cities/#{city.id}", headers: { 'x-device-id' => user.device_id }
    end

    it 'returns a deleted status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /change' do
    let(:first_city) do
      create(:city, city_id: 2_673_730, city_name: 'Stockholm',
                    country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 1, user_id: user.id)
    end
    let(:second_city) do
      create(:city, city_id: 2_673_731, city_name: 'Stockholm',
                    country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 2, user_id: user.id)
    end

    before do
      put '/api/v1/user/cities/city_order',
          params: { cities: [{ id: first_city.id, order: 2 }, { id: second_city.id, order: 1 }] },
          headers: { 'x-device-id' => user.device_id }
    end

    it 'returns a update status' do
      expect(response).to have_http_status(:ok)
    end

    it 'changes order for city1' do
      expect(City.find(first_city.id).order).to eq(2)
    end

    it 'changes order for city2' do
      expect(City.find(second_city.id).order).to eq(1)
    end
  end

  describe 'GET /city' do
    let(:city) do
      create(:city, city_id: 2_673_730, city_name: 'Stockholm',
                    country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 1, user_id: user.id)
    end

    before do
      get "/api/v1/user/cities/#{city.id}", headers: { 'x-device-id' => user.device_id }
    end

    it 'returns an ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns city_id' do
      expect(JSON.parse(response.body)['city_id']).to eq(city.city_id)
    end

    it 'returns id' do
      expect(JSON.parse(response.body)['id']).to eq(city.id)
    end
  end

  describe 'GET /cities' do
    before do
      create(:city, city_id: 2_673_731, city_name: 'Stockholm',
                    country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 2, user_id: user.id)
      create(:city, city_id: 2_673_730, city_name: 'Stockholm',
                    country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 1, user_id: user.id)
      get '/api/v1/user/cities', headers: { 'x-device-id' => user.device_id }
    end

    it 'returns an ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns cities' do
      expect(JSON.parse(response.body)['cities'].length).to eq(2)
    end

    it 'returns the first city' do
      expect(JSON.parse(response.body)['cities'][0]['city_id']).to eq(2_673_730)
    end

    it 'returns the second city' do
      expect(JSON.parse(response.body)['cities'][1]['city_id']).to eq(2_673_731)
    end
  end
end
