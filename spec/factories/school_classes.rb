FactoryBot.define do
  factory :school_class do
    name { "Turma #{Faker::Number.number(digits: 2)}" }
    semester { "2025" }  # Adiciona um valor padrão para o semestre
    association :subject  # O subject já contém a associação com department
  end
end