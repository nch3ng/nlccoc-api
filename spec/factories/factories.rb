FactoryBot.define do
  factory :role do
    name "normal"
  end

  factory :organization, aliases: [:org] do
    name "Test Org Name"
    address "17 Ninos, Pomona, CA 91234"
  end

  factory :user do
    first_name "John"
    last_name "Doe"
    email "johndoe@test.com"
    role
    org
  end
end