FactoryBot.define do
  factory :lista_estatica do
    nombre { "una lista estatica" }
    filtro factory: :filtro_por_atributo
  end
end
