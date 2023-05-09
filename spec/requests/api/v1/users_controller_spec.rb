require 'rails_helper'

RSpec.describe 'Users' do
  let!(:question) { create(:question, question: 'Do you like to wear caps?', label: :sandalUser) }
  let!(:question2) { create(:question, question: 'Do you wear shorts at all?', label: :shortUser) }

  before do
    create(:question, question: 'Do you wear sandals at all?', label: :capUser)
    create(:question, question: 'Are you warmer or colder dressed than the people around you?', label: :userPlace)
    create(:question, question: 'Do you live in a hot or cold place?', label: :userTemp)
  end

  describe 'GET /info' do
    context 'when the information is requested' do
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
        VCR.use_cassette('userInfo_index') do
          get '/api/v1/user?temperature=true&weathercode=true&windspeed=true&is_day=true&relativehumidity_2m=true
&apparent_temperature=true',
              headers: { 'x-device-id' => device_id }
        end
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'creates user' do
        user = User.find_by(device_id:)
        expect(user.device_id).to eq(device_id)
      end

      it 'returns one city id' do
        expect(JSON.parse(response.body)['cities'][0]['id']).to eq(city_bs.id)
      end

      it 'returns another city id' do
        expect(JSON.parse(response.body)['cities'][1]['id']).to eq(city_st.id)
      end

      it 'returns the relative humidity' do
        expect(JSON.parse(response.body)['cities'][0]['weather']['relativehumidity_2m']).to be_a(Integer)
      end

      it 'returns the apparent temperature' do
        expect(JSON.parse(response.body)['cities'][0]['weather']['apparent_temperature']).to be_a(Float)
      end

      it 'returns the precipitation probability' do
        expect(JSON.parse(response.body)['cities'][0]['weather']['precipitation_probability']).to be_a(Integer)
      end

      it 'returns the direct radiation' do
        expect(JSON.parse(response.body)['cities'][0]['weather']['direct_radiation']).to be_a(Float)
      end

      it 'returns the clothing recommendation' do
        expect(JSON.parse(response.body)['cities'][0]['recommendation']).to be_a(Array)
      end

      it 'returns the user temp unit' do
        expect(JSON.parse(response.body)['user_temp_unit']).to eq('celsius')
      end

      it 'returns the user gender' do
        expect(JSON.parse(response.body)['gender']).to eq('female')
      end

      it 'returns the user look' do
        expect(JSON.parse(response.body)['look']).to eq(0)
      end
    end

    context 'when no user exist, creates one' do
      let(:device_id) { 'k123v23hj213321jh12kj3123k' }

      before do
        create(:city, name: 'Stockholm', weather_id: 2_673_730, country: 'Sweden', latitude: 59.33459,
                      longitude: 18.06324)
        create(:cloth_type, name: 'charizard', section: 'pokemon')
        VCR.use_cassette('userNewInfo_index') do
          get '/api/v1/user', headers: { 'x-device-id' => device_id }
        end
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'creates user' do
        user = User.find_by(device_id:)
        expect(user.device_id).to eq(device_id)
      end

      it 'creates default answers' do
        user = User.find_by(device_id:)
        expect(user.answers).to eq({ 'sandalUser' => 0, 'shortUser' => 0, 'capUser' => 0, 'userPlace' => 0,
                                     'userTemp' => 0 })
      end

      it 'returns the main city' do
        expect(JSON.parse(response.body)['cities'][0]['weather_id']).to eq(2_673_730)
      end

      it 'returns the user cloth preferences' do
        expect(JSON.parse(response.body)['preferences']['charizard']).to eq(0)
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

      # @todo check whether specified error message is sent
    end
  end

  describe 'Destroy' do
    context 'when requested to remove a city id from list of cities ids' do
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

    context('when requested to delete a nonexistent city') do
      let(:user) { create(:user, device_id: 'k123v23hj213321jh12kj3123k', cities_ids: [2, 4, 8]) }

      before do
        patch '/api/v1/user/cities/destroy', headers: { 'x-device-id' => user.device_id }, params: { city_id: 5 }
      end

      it 'returns a specified error message' do
        expect(JSON.parse(response.body)['error']).to eq('city_id_not_found')
      end

      it 'returns bad request error status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'Order' do
    let(:user) { create(:user, device_id: 'k123v23hj213321jh12kj3123k', cities_ids: [5, 2, 4, 8]) }

    context 'when requested to reorder cities' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 2, 5] }
      end

      it 'returns success request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'changes the city order correctly' do
        expect(user.reload.cities_ids).to eq([8, 4, 2, 5])
      end
    end

    context 'when requested to change order with a missing id' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 2] }
      end

      it 'returns a specified error message' do
        expect(JSON.parse(response.body)['error']).to eq('added or missing id')
      end

      it 'returns bad request error status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when requested to change order with an added id' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 2, 5, 7] }
      end

      it 'returns a specified error message' do
        expect(JSON.parse(response.body)['error']).to eq('added or missing id')
      end

      it 'returns bad request error status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when requested to change order with duplicate id' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 5, 5] }
      end

      it 'returns a specified error message' do
        expect(JSON.parse(response.body)['error']).to eq('duplicate id')
      end

      it 'returns bad request error status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when requested to change order with incorrect cities ids (flawed order)' do
      before do
        patch '/api/v1/user/cities/change_order', headers: { 'x-device-id' => user.device_id },
                                                  params: { cities_ids: [8, 4, 5, 3] }
      end

      it 'returns a specified error message' do
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

    context 'when requested to add a city (given city is already in city table)' do
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

    context 'when requested to add a city that the user already has' do
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

      it 'returns a specified error message' do
        expect(JSON.parse(response.body)['error']).to eq('the city is already added')
      end
    end
  end

  describe 'GET QUESTIONS' do
    let(:device_id) { 'k123v23hj213321jh12kj3123k' }

    before do
      create(:city, name: 'Stockholm', weather_id: 2_673_730, country: 'Sweden', latitude: 59.33459,
                    longitude: 18.06324)
    end

    context 'when requested questions' do
      before do
        get '/api/v1/user/questions/all', headers: { 'x-device-id' => device_id }
      end

      it 'returns ok request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns question 1 with correct id' do
        expect(JSON.parse(response.body)['questions'][0]['question_label']).to eq(question.label)
      end

      it 'returns question 1 max possible response' do
        expect(JSON.parse(response.body)['questions'][0]['max']).to eq(1)
      end

      it 'returns question 1 min possible response' do
        expect(JSON.parse(response.body)['questions'][0]['min']).to eq(0)
      end

      it 'returns question 2 with correct id' do
        expect(JSON.parse(response.body)['questions'][1]['question_label']).to eq(question2.label)
      end

      it 'returns question 2 with answer 0' do
        expect(JSON.parse(response.body)['questions'][1]['answer']).to eq(0)
      end
    end

    context 'when modified questions' do
      before do
        patch '/api/v1/user/questions/answer', headers: { 'x-device-id' => device_id },
                                               params: { questions: { "#{question.label}": 1,
                                                                      "#{question2.label}": 1 } }
      end

      it 'returns ok request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns ok when modifies question successfully' do
        expect(User.first.answers[question.label.to_s]).to eq(1)
      end

      it 'returns nil when modifies more than one question correctly' do
        expect(User.first.answers[question2.label.to_s]).to eq(1)
      end
    end
  end

  describe 'MODIFY PREFERENCES' do
    let(:device_id) { 'k123v23hj213321jh12kj3123k' }
    let(:cloth_one) { create(:cloth_type) }
    let(:cloth_two) { create(:cloth_type) }

    before do
      create(:city, name: 'Stockholm', weather_id: 2_673_730, country: 'Sweden', latitude: 59.33459,
                    longitude: 18.06324)
    end

    context 'when modified questions' do
      before do
        patch '/api/v1/user/cloth/change_cloth', headers: { 'x-device-id' => device_id },
                                                 params: { preferences: { "#{cloth_one.name}": 1,
                                                                          "#{cloth_two.name}": 1 } }
      end

      it 'returns ok request status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns ok when modifies question successfully' do
        expect(User.first.preferences[cloth_one.name]).to eq(1)
      end

      it 'returns nil when modifies more than one question correctly' do
        expect(User.first.preferences[cloth_two.name]).to eq(1)
      end
    end
  end
end
