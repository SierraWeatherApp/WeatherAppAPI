require 'rails_helper'

RSpec.describe User do
  let(:user_test) { create(:user, device_id: '19238723y7dh3su2as21dfs231a213sd2af', cities_ids: [1, 2, 3]) }

  it 'is valid with valid attributes' do
    expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag')).to be_valid
  end

  it 'is invalid without device_id' do
    expect(described_class.new).not_to be_valid
  end

  it 'is invalid to have the same device_id' do
    expect(described_class.new(device_id: user_test.device_id)).not_to be_valid
  end

  it 'is invalid to repeat the city_id for a specific user' do
    expect(described_class.new(cities_ids: user_test.cities_ids.push(3))).not_to be_valid
  end

  it 'is invalid to send incorrect temperature format' do
    expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag', temp_units: "f")).not_to be_valid
  end
end
