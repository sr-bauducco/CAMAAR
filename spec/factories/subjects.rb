FactoryBot.define do
  factory :subject do
    name { "Matemática" }
    code { "MAT101" }
    department { association(:department) }
  end
end