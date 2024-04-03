FactoryBot.define do
  factory :filtro do
    nombre { "un filtro" }
    condiciones { { s => "tipo_donante asc" } }
  end
end
