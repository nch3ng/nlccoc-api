FactoryBot.define do
  factory :department do
    sequence(:name) {|n| "Department #{n} name" }
    organization_id 1
  end
end
