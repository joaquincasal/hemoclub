FactoryBot.define do
  factory :clinica do
    nombre { "Bazterrica" }
    codigo { rand(1...500) }
  end
end
