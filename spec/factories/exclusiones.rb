FactoryBot.define do
  factory :exclusion do
    fecha_inicio { "2024-03-03" }
    fecha_fin { "2030-03-04" }
    motivo { "motivo" }
    donante
  end
end
