require 'rails_helper'

RSpec.describe User do
  let(:device_id) { '19238723y7dh3su2as21dfs231a213sd2af' }

  it 'is valid with valid attributes' do
    expect(described_class.new(device_id:)).to be_valid
  end

  it 'is invalid without device_id' do
    expect(described_class.new).not_to be_valid
  end
end
