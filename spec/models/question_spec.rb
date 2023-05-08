require 'rails_helper'

RSpec.describe Question do
  before do
    create(:question, question: 'Do you like to wear caps?', label: :capUser)
  end

  it 'is valid with valid attributes' do
    expect(described_class.new(question: 'Do you like to wear sandals?', label: :sandalUser)).to be_valid
  end

  it 'is invalid without question' do
    expect(described_class.new(label: :sandalUser)).not_to be_valid
  end

  it 'is invalid without label' do
    expect(described_class.new(question: 'Do you like to wear sandals?')).not_to be_valid
  end

  it 'is invalid without both question and label' do
    expect(described_class.new).not_to be_valid
  end

  it 'is invalid to have the same question' do
    expect(described_class.new(question: 'Do you like to wear caps?', label: :sandalUser)).not_to be_valid
  end

  it 'is invalid to have the same label' do
    expect(described_class.new(question: 'Do you like to wear sandals?', label: :capUser)).not_to be_valid
  end

  it 'is invalid to have both the same question and label' do
    expect(described_class.new(question: 'Do you like to wear caps?', label: :capUser)).not_to be_valid
  end

  it 'is invalid to have min higher than max' do
    expect(described_class.new(question: 'Do you like to wear sandals?', label: :sandalUser, min: 10,
                               max: 5)).not_to be_valid
  end

  it 'is invalid to not have 0 in the range' do
    expect(described_class.new(question: 'Do you like to wear sandals?', label: :sandalUser, min: 1,
                               max: 5)).not_to be_valid
  end

  it 'is invalid to have label that is larger than prescribed range' do
    expect { described_class.new(question: 'Do you like to wear sandals?', label: 100) }
      .to raise_error(ArgumentError, "'100' is not a valid label")
  end
end
