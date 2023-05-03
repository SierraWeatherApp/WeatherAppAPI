require 'rails_helper'

RSpec.describe Question do
  before do
    create(:question, question: 'Do you like dogs?')
  end

  it 'is valid with valid attributes' do
    expect(described_class.new(question: 'Do you like apples?')).to be_valid
  end

  it 'is invalid without question' do
    expect(described_class.new).not_to be_valid
  end

  it 'is invalid to have the same question' do
    expect(described_class.new(question: 'Do you like dogs?')).not_to be_valid
  end

  it 'is invalid to have min higher than max' do
    expect(described_class.new(question: 'Do you like studying', min: 10, max: 5)).not_to be_valid
  end

  it 'is invalid to not have 0 in the range' do
    expect(described_class.new(question: 'Do you like studying', min: 1, max: 5)).not_to be_valid
  end
end

