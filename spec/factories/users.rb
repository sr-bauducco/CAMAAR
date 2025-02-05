FactoryBot.define do
  factory :user do
    name { "Usuário Padrão" }
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    registration_number { SecureRandom.hex(5) }
    department

    trait :admin do
      role { :admin }
    end
  end
end
