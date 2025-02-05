FactoryBot.define do
  factory :user do
    name { "Admin User" }
    email { "admin@example.com" }
    password { "password123" }
    registration_number { "1" }
    department { create(:department) }

    trait :admin do
      role { "admin" }
    end
  end
end
