FactoryBot.define do
  factory :clinica do
    nombre { "Bazterrica" }
    codigo { rand(1...999_999_999) }
  end
end
