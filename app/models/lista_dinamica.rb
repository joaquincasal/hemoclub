class ListaDinamica < Lista
  def donantes
    # FIXME
    Donante.limit(1)
  end
end
