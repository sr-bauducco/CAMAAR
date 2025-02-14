FactoryBot.define do
  factory :form_template do
    name { "Template #{Faker::Number.number(digits: 2)}" }
    questions do
      [
        { "text" => "Qual sua opinião sobre o curso?", "response_type" => "text" },
        { "text" => "Qual sua nota para o professor?", "response_type" => "multiple_choice", "options" => ["Ruim", "Regular", "Bom", "Ótimo"] }
      ]
    end
    association :department
  end
end
