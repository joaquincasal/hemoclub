FactoryBot.define do
  factory :lista_dinamica do
    nombre { "una lista dinamica" }
    filtro factory: :filtro_por_atributo
  end
end
