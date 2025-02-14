FactoryBot.define do
  factory :form_template do
    name { "Template #{Faker::Number.number(digits: 2)}" }
    questions_array { ["Pergunta 1", "Pergunta 2"] }
    association :department
  end
end