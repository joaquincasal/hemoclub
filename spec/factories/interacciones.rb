FactoryBot.define do
  factory :interaccion do
    donante
    ejecucion
    comunicacion factory: %i[campania]
    fecha { "2024-01-01" }
  end
end
