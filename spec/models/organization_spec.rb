require 'rails_helper'

RSpec.describe Organization, type: :model do

  before(:all) do
    @org1 = create(:organization)
  end

  it 'has a valid factory' do
    expect(@org1).to be_valid
  end


  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
  end
end