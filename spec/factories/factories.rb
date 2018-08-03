FactoryBot.define do
  factory :role do
    name "normal"
    
    trait :normal do
      name "normal"
    end

    trait :admin do
      name   "admin"
    end

    trait :manager do
      name "manager"
    end

    trait :accountant do
      name "accountant"
    end

    trait :employee do
      name "employee"
    end
  end

  factory :organization, aliases: [:org] do
    name "Test Org Name"
    address "17 Ninos, Pomona, CA 91234"
  end

  factory :user do
    sequence(:email) {|n| "johndoe#{n}@test.com" }
    first_name "John"
    last_name "Doe"
    role_id 1
    org_id 1
  end
end