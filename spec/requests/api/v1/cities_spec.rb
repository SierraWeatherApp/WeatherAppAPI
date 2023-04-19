require 'rails_helper'

RSpec.describe "Cities", type: :request do
  describe "POST /create" do
    #pending "add some examples (or delete) #{__FILE__}"
    before do 
      post "/api/v1/cities", params:{
                city_id: 2673730,
                city_name: "Stockholm",
                country: "Sweden",
                latitude: 59.33459,
                longitude: 18.06324,
              }
    end
    it 'returns a created status' do
      expect(response).to have_http_status(:created)
    end
  end
  describe 'DELETE /destroy' do 
    let(:city){create(:city, city_id: 2673730, city_name: "Stockholm",
      country: "Sweden", latitude: 59.33459, longitude: 18.06324,order:1)} 
    before do
      delete "/api/v1/cities/#{city.id}"
    end
    it 'returns a deleted status' do
      expect(response).to have_http_status(:ok)
    end
  end
  describe 'PUT /change' do 
    let(:city1){create(:city, city_id: 2673730, city_name: "Stockholm",
      country: "Sweden", latitude: 59.33459, longitude: 18.06324,order:1)}
    let(:city2){create(:city, city_id: 2673730, city_name: "Stockholm",
        country: "Sweden", latitude: 59.33459, longitude: 18.06324,order:2)} 
    before do
      put "/api/v1/cities/city_order", params: {cities: [{id: city1.id, order: 2},{id:city2.id, order:1}]}
    end
    it 'returns a update status' do
      expect(response).to have_http_status(:ok)
    end
  end

end
