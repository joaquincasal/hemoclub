FactoryBot.define do
  factory :filtro_por_atributo, class: 'Filtro' do
    parametros do
      [{ atributo: "tipo_donante",
         operador: "distinto",
         valor: "reposicion" }]
    end
    type { "FiltroPorAtributo" }
  end
end
