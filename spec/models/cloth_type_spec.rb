require 'rails_helper'

RSpec.describe ClothType do
  before do
    create(:cloth_type, name: 'shirt_hoodie', section: 'shirt')
  end

  it 'is valid with valid attributes' do
    expect(described_class.new(name: 'sweater_hoodie', section: 'sweater')).to be_valid
  end

  it 'is invalid without name' do
    expect(described_class.new(section: 'sweater')).not_to be_valid
  end

  it 'is invalid without type' do
    expect(described_class.new(name: 'sweater')).not_to be_valid
  end

  it 'is invalid with valid attributes but duplicate values' do
    expect(described_class.new(name: 'shirt_hoodie', section: 'shirt')).not_to be_valid
  end
end

