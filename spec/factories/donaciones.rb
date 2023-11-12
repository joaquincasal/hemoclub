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

  trait :predonante_rechazado do
    predonante_plaquetas { true }
    motivo_rechazo_predonante_plaquetas { "conteo insuficiente" }
  end
end
