class OrgDept < ApplicationRecord
  belongs_to :organization
  belongs_to :department
end
