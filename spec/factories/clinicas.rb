FactoryBot.define do
  factory :clinica do
    nombre { "Bazterrica" }
    codigo { rand(1...5000) }
  end
end
