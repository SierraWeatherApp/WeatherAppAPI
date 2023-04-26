require 'rails_helper'

RSpec.describe City do
  before do
    create(:city, weather_id: 10, latitude: 43.2, longitude: 44.5)
  end

  it 'is valid with valid attributes' do
    expect(described_class.new(weather_id: 11, name: 'Stockholm', country: 'Sweden', latitude: 0, longitude: 0)).to be_valid
  end

  it 'is invalid without any attributes' do
    expect(described_class.new).not_to be_valid
  end

  it 'is invalid without any weather_id' do
    expect(described_class.new(name: 'Stockholm', country: 'Sweden', latitude: 0, longitude: 0)).not_to be_valid
  end

  it 'is invalid without any city name' do
    expect(described_class.new(weather_id: 11, country: 'Sweden', latitude: 0, longitude: 0)).not_to be_valid
  end

  it 'is invalid without any country name' do
    expect(described_class.new(weather_id: 11, name: 'Stockholm', latitude: 0, longitude: 0)).not_to be_valid
  end

  it 'is invalid without any latitude' do
    expect(described_class.new(weather_id: 11, name: 'Stockholm', country: 'Sweden', longitude: 0)).not_to be_valid
  end

  it 'is invalid without any longitude' do
    expect(described_class.new(weather_id: 11, name: 'Stockholm', country: 'Sweden', latitude: 0)).not_to be_valid
  end

  it 'is invalid to have the same weather_id' do
    expect(described_class.new(weather_id: 10)).not_to be_valid
  end

  it 'is invalid to have the same latitude and longitude for different city entries' do
    expect(described_class.new(weather_id: 12, name: 'Stockholm',
                               country: 'Sweden', latitude: 43.2,
                               longitude: 44.5)).not_to be_valid
  end
end
