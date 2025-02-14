# spec/factories/school_classes.rb
FactoryBot.define do
  factory :school_class do
    name { "Turma A" }  # Atribui um valor padrão para name
    semester { "2025/01" }
    association :subject  # Cria o subject associado
  end
end
