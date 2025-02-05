FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    matricula { Faker::Number.number(digits: 8) }
    password { "password" }
    role { :participant }
  end
end
