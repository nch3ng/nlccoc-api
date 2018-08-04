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
    sequence(:name) {|n| "Organization #{n} name" }
    sequence(:address) {|n| "Organization #{n} address" }
  end

  factory :user do
    sequence(:email) {|n| "johndoe#{n}@test.com" }
    first_name "John"
    last_name "Doe"
    department_id  nil
    role_id 1
    org_id 1
  end
end