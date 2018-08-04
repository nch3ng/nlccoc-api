class Organization < ApplicationRecord
  has_many :users, :as => :org, :dependent => :destroy
  has_many :org_depts
  has_many :departments, through: :org_depts
  validates :name, presence: true
  validates :address, presence: true
end
