class ListaDinamica < Lista
  def donantes
    Donante.ransack(filtro.condiciones).result.includes(:donaciones)
  end
end
