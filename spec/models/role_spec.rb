require 'rails_helper'

RSpec.describe Role, type: :model do

  before(:all) do
    @role1 = create(:role)
  end

  it 'has a valid factory' do
    expect(@role1).to be_valid
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end