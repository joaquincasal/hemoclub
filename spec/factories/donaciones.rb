FactoryBot.define do
  factory :donacion do
    fecha { 1.day.ago.to_date }
    serologia { "negativa" }
    tipo_donante { "reposicion" }
    donante
    clinica
  end

  trait :rechazada do
    motivo_rechazo { 0 }
  end
end
