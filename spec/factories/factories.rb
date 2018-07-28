FactoryBot.define do
  factory :role do
    name "normal"
  end

  factory :organization, aliases: [:org] do
    name "Test Org Name"
    address "17 Ninos, Pomona, CA 91234"
  end

  factory :user do
    sequence(:email) {|n| "johndoe#{n}@test.com" }
    first_name "John"
    last_name "Doe"
    role
    org
  end
end