FactoryBot.define do
  factory :department do
    name { Faker::University.name }  # Gera um nome aleatório e único
  end
end