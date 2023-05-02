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

  context 'when requested to update temperature units' do
    it 'is valid to change to celsius' do
      expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag', temp_unit: 'celsius')).to be_valid
    end

    it 'is valid to change to fahrenheit' do
      expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag',
                                 temp_unit: 'fahrenheit')).to be_valid
    end

    it 'is invalid to change to incorrect temperature format' do
      expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag', temp_unit: 'f')).not_to be_valid
    end
  end

  context 'when requested to update gender' do
    it 'is valid to change to female' do
      expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag', gender: 'female')).to be_valid
    end

    it 'is valid to change to male' do
      expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag', gender: 'male')).to be_valid
    end

    it 'is invalid to change to incorrect gender format' do
      expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag', gender: '-')).not_to be_valid
    end
  end

  context 'when requested to update looks' do
    it 'is valid to change look to number larger or equal to zero' do
      expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag',
                                 look: 1)).to be_valid
    end

    it 'is invalid to change look to number that is smaller than zero' do
      expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag',
                                 look: -1)).not_to be_valid
    end

    it 'is invalid to change look to anything but a number' do
      expect(described_class.new(device_id: '19238723y7dh3su2as21dfs231a213sd2ag',
                                 look: 'h')).not_to be_valid
    end
  end
end
