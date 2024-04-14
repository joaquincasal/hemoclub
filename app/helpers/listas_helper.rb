module ListasHelper
  def condiciones_filtro(lista_dinamica)
    condiciones = []
    filtros = lista_dinamica.filtro.condiciones['c'] || []
    filtros.each do |_, hash_condiciones|
      atributo = hash_condiciones['a']['0']['name']
      predicado = t("ransack.predicates.#{hash_condiciones['p']}")
      valor = hash_condiciones['v']['0']['value']
      condiciones.append({atributo: atributo, predicado: predicado, valor: valor})
    end
    condiciones
  end
end
