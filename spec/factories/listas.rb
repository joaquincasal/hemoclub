FactoryBot.define do
  factory :lista do
    nombre { "una lista" }
    filtro factory: :filtro_por_atributo
  end
end
