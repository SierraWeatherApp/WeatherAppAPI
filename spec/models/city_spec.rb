require 'rails_helper'

RSpec.describe City do
  let(:user) { create(:user, device_id: '19238723y7dh3su2as21dfs231a213sd2af') }

  it 'is valid with valid attributes' do
    expect(described_class.new(city_name: 'City', country: 'Country',
                               latitude: 0.0, longitude: 0.0, order: 1, city_id: 1, user_id: user.id)).to be_valid
  end
end
