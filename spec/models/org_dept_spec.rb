require 'rails_helper'

RSpec.describe OrgDept, type: :model do

  before(:all) do
    @org = create(:organization)
    @dept = create(:department)
  end

  context 'relations' do
    it { should belong_to(:department) }
    it { should belong_to(:organization) }
  end
end
