require 'rails_helper'

RSpec.describe City, type: :model do
  it 'is valid with valid attributes' do
    expect(described_class.new(city_name: 'City', country: 'Country',
       latitude: 0.0, longitude: 0.0, order: 1, city_id: 1))
  end
end
