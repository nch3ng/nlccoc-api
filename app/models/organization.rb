class Organization < ApplicationRecord
  has_many :users, :as => :org, :dependent => :destroy
  validates :name, presence: true
  validates :address, presence: true
end
