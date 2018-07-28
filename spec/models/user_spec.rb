require 'rails_helper'

RSpec.describe User, type: :model do

  before(:all) do
    @user1 = create(:user, email: 'johndoe@test.com')
    puts @user1.inspect
  end

  it 'has a valid factory' do
    expect(@user1).to be_valid
  end

  it 'has default value of validated' do
    expect(@user1.validated).to be(false)
  end

  it "has a unique email" do

    user2 = build(:user, email: 'johndoe@test.com')
    expect(user2).to_not be_valid
  end

  context 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end