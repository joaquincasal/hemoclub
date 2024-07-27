FactoryBot.define do
  factory :filtro_por_atributo, class: 'Filtro' do
    parametros do
      [{ atributo: "tipo_donante",
         operador: "distinto",
         valor: "reposicion",
         tipo: "FiltroPorAtributo"}]
    end
  end
end
