class ListaEstatica < Lista
  has_and_belongs_to_many :donantes

  def set_donantes
    self.donantes = filtro.aplicar
  end
end
