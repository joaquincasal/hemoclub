FactoryBot.define do
  factory :ejecucion do
    comunicacion factory: %i[campania]
    fecha { "2024-04-21 18:28:34" }
  end
end
