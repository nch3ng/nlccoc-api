require 'rails_helper'

RSpec.describe Department, type: :model do
  before(:all) do
    @org = create(:organization)
    @dept = create(:department)
  end

  it 'has a valid factory' do
    expect(@dept).to be_valid
  end

  context 'relations' do
    it { should have_many(:users) }
    it { should have_many(:org_depts)}
    it { should have_many(:organizations).through(:org_depts)}
  end


  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end
