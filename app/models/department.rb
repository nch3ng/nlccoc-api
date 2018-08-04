class Department < ApplicationRecord
  has_many :users
  has_many :org_depts
  has_many :organizations, through: :org_depts
  validates :name, presence: true
end
