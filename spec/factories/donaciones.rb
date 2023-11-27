FactoryBot.define do
  factory :donacion do
    codigo_ingreso { "1234" }
    fecha { 1.day.ago.to_date }
    serologia { "negativa" }
    donante
    clinica
  end

  trait :rechazada do
    motivo_rechazo { "autoexclusion" }
  end
end
