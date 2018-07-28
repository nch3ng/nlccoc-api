class Organization < ApplicationRecord
  has_many :users, :as => :org
  validates :name, presence: true
  validates :address, presence: true
end
