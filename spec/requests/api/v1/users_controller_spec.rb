require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /info' do
    context 'when returns the weather of cities' do
      let(:device_id) { 'k123v23hj213321jh12kj3123k' }
      let(:city_st) do
        create(:city, name: 'Stockholm', weather_id: 2_673_730, country: 'Sweden', latitude: 59.33459,
                      longitude: 18.06324)
      end
      let(:city_bs) do
        create(:city, name: 'Buenos Aires', weather_id: 3_435_910, country: 'Argentina', latitude: -34.61315,
                      longitude: -58.37723)
      end

      before do
        create(:user, device_id:, cities_ids: [city_bs.id, city_st.id])
        get '/api/v1/user?temperature=true&weathercode=true&windspeed=true&is_day=true&relativehumidity_2m=true',
            headers: { 'x-device-id' => device_id }
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'creates user' do
        user = User.find_by(device_id:)
        expect(user.device_id).to eq(device_id)
      end

      it 'returns the cities ids and their weather' do
        expect(JSON.parse(response.body)['cities'][0]['id']).to eq(city_bs.id)
      end
    end

    context 'when no user exist, creates one' do
      let(:device_id) { 'k123v23hj213321jh12kj3123k' }

      before do
        create(:city, name: 'Stockholm', weather_id: 2_673_730, country: 'Sweden', latitude: 59.33459,
                      longitude: 18.06324)
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
        expect(JSON.parse(response.body)['cities'][0]['weather_id']).to eq(2_673_730)
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

  describe 'updating user info' do
    let(:device_id) { 'k123v23hj213321jh12kj3123k' }
    let(:city_st) do
      create(:city, name: 'Stockholm', weather_id: 2_673_730, country: 'Sweden', latitude: 59.33459,
             longitude: 18.06324)
    end
    let(:city_bs) do
      create(:city, name: 'Buenos Aires', weather_id: 3_435_910, country: 'Argentina', latitude: -34.61315,
             longitude: -58.37723)
    end

    before do
      create(:user, device_id:, cities_ids: [city_bs.id, city_st.id])
    end

    context 'when requested to update temperature unit' do
      before do
        patch '/api/v1/user?temp_unit=fahrenheit',
              headers: { 'x-device-id' => device_id }
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'saves information' do
        user = User.find_by(device_id:)
        expect(user.reload.temp_unit).to eq('fahrenheit')
      end

      it 'does not change gender' do
        user = User.find_by(device_id:)
        expect(user.reload.gender).to eq('female')
      end

      it 'does not change look' do
        user = User.find_by(device_id:)
        expect(user.reload.look).to eq(0)
      end
    end

    context 'when requested to update temp_unit with incorrect data format' do
      before do
        patch '/api/v1/user?temp_unit=car',
              headers: { 'x-device-id' => device_id }
      end

      it 'returns bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'gives incorrect_temp_format error message' do
        expect(JSON.parse(response.body)['error']).to eq('Validation failed: Temp unit incorrect_temp_format')
      end
    end

    context 'when requested to update gender' do
      before do
        patch '/api/v1/user?gender=male',
              headers: { 'x-device-id' => device_id }
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'saves information' do
        user = User.find_by(device_id:)
        expect(user.reload.gender).to eq('male')
      end

      it 'does not change temperature' do
        user = User.find_by(device_id:)
        expect(user.reload.temp_unit).to eq('celsius')
      end

      it 'does not change look' do
        user = User.find_by(device_id:)
        expect(user.reload.look).to eq(0)
      end
    end

    context 'when requested to update gender with incorrect data format' do
      before do
        patch '/api/v1/user?gender=gender',
              headers: { 'x-device-id' => device_id }
      end

      it 'returns bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'gives incorrect_gender_format error message' do
        expect(JSON.parse(response.body)['error']).to eq('Validation failed: Gender incorrect_gender_format')
      end
    end

    context 'when requested to update look' do
      before do
        patch '/api/v1/user?look=9',
              headers: { 'x-device-id' => device_id }
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'saves information' do
        user = User.find_by(device_id:)
        expect(user.reload.look).to eq(9)
      end

      it 'does not change temperature' do
        user = User.find_by(device_id:)
        expect(user.reload.temp_unit).to eq('celsius')
      end

      it 'does not change gender' do
        user = User.find_by(device_id:)
        expect(user.reload.gender).to eq('female')
      end
    end

    context 'when requested to update look with incorrect data format (not an integer)' do
      before do
        patch '/api/v1/user?look=h',
              headers: { 'x-device-id' => device_id }
      end

      it 'returns bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'gives incorrect_look_format error message' do
        expect(JSON.parse(response.body)['error']).to eq('Validation failed: Look is not a number')
      end
    end

    context 'when requested to update look with incorrect data format (number smaller than zero)' do
      before do
        patch '/api/v1/user?look=-1',
              headers: { 'x-device-id' => device_id }
      end

      it 'returns bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'gives incorrect_look_format error message' do
        expect(JSON.parse(response.body)['error']).to eq('Validation failed: Look must be greater than or equal to 0')
      end
    end
  end

  describe 'Destroy' do
    context 'when removes city id from list of cities ids for user' do
      let(:user) { create(:user, device_id: 'k123v23hj213321jh12kj3123k', cities_ids: [2, 4, 8]) }

      before do
        patch '/api/v1/user/cities/destroy', headers: { 'x-device-id' => user.device_id }, params: { city_id: 4 }
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'deletes specified city' do
        expect(user.reload.cities_ids).to eq([2, 8])
      end
    end

    context('when tries to delete nonexistent city in users list of cities') do
      let(:user) { create(:user, device_id: 'k123v23hj213321jh12kj3123k', cities_ids: [2, 4, 8]) }

      before do
        patch '/api/v1/user/cities/destroy', headers: { 'x-device-id' => user.device_id }, params: { city_id: 5 }
      end

      it 'returns city_id_not_found_error' do
        expect(JSON.parse(response.body)['error']).to eq('city_id_not_found')
      end

      it 'returns bad request error status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'Order' do
    let(:user) { create(:user, device_id: 'k123v23hj213321jh12kj3123k', cities_ids: [5, 2, 4, 8]) }

    context 'when orders cities as requested' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 2, 5] }
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'changed the city order correctly' do
        expect(user.reload.cities_ids).to eq([8, 4, 2, 5])
      end
    end

    context 'when gives error because the order is flawed (missing id)' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 2] }
      end

      it 'returns added or missing id error message' do
        expect(JSON.parse(response.body)['error']).to eq('added or missing id')
      end

      it 'returns bad request error status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when gives error because the order is flawed (added id)' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 2, 5, 7] }
      end

      it 'returns added or missing id error message' do
        expect(JSON.parse(response.body)['error']).to eq('added or missing id')
      end

      it 'returns bad request error status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when gives error because the order is flawed (duplicate id)' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 5, 5] }
      end

      it 'returns duplicate id error message' do
        expect(JSON.parse(response.body)['error']).to eq('duplicate id')
      end

      it 'returns bad request error status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when gives error because the order is flawed (flawed order) message' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 5, 3] }
      end

      it 'returns flawed order of cities error message' do
        expect(JSON.parse(response.body)['error']).to eq('flawed order of cities')
      end

      it 'returns bad request error status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'ADD CITY' do
    let(:user) { create(:user, device_id: 'k123v23hj213321jh12kj3123k', cities_ids: [5, 2, 4, 8]) }

    before do
      create(:city, weather_id: 1, name: 'Stockholm', country: 'Sweden', latitude: 10, longitude: 10)
    end

    context 'when adds a city as requested (assuming that city already exists in a table)' do
      before do
        put '/api/v1/user/cities/add', headers: { 'x-device-id' => user.device_id },
                                       params: { weather_id: 1, name: 'Stockholm',
                                                 country: 'Sweden', latitude: 10, longitude: 10 }
      end

      it 'returns created request status' do
        expect(response).to have_http_status(:created)
      end

      it 'adds a city to a list of users cities' do
        city = City.find_by(weather_id: 1)
        expect(user.reload.cities_ids).to eq([5, 2, 4, 8, city.id])
      end
    end

    context 'when adding an already existing city' do
      before do
        put '/api/v1/user/cities/add', headers: { 'x-device-id' => user.device_id },
                                       params: { weather_id: 1, name: 'Stockholm', country: 'Sweden',
                                                 latitude: 10, longitude: 10 }
        put '/api/v1/user/cities/add', headers: { 'x-device-id' => user.device_id },
                                       params: { weather_id: 1, name: 'Stockholm', country: 'Sweden',
                                                 latitude: 10, longitude: 10 }
      end

      it 'returns bad request request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns the city is already added error message' do
        expect(JSON.parse(response.body)['error']).to eq('the city is already added')
      end
    end
  end
end
