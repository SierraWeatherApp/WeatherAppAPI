require 'rails_helper'

RSpec.describe City do
  let(:user) { create(:user, device_id: '19238723y7dh3su2as21dfs231a213sd2af') }

  it 'is valid with valid attributes' do
    expect(described_class.new(city_name: 'City', country: 'Country',
                               latitude: 0.0, longitude: 0.0, order: 1, city_id: 1, user_id: user.id)).to be_valid
  end
  it 'is not valid with same order' do
    create(:city, city_id: 2_673_731, city_name: 'Stockholm',
      country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 1, user_id: user.id)
    expect(described_class.new(city_name: 'City', country: 'Country',
                               latitude: 0.0, longitude: 0.0, order: 1, city_id: 1, user_id: user.id)).not_to be_valid
  end
  it 'is not valid with same city_id' do
    create(:city, city_id: 1, city_name: 'Stockholm',
      country: 'Sweden', latitude: 59.33459, longitude: 18.06324, order: 1, user_id: user.id)
    expect(described_class.new(city_name: 'City', country: 'Country',
                               latitude: 0.0, longitude: 0.0, order: 2, city_id: 1, user_id: user.id)).not_to be_valid
  end
end
