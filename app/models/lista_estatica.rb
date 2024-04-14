class ListaEstatica < Lista
  has_and_belongs_to_many :donantes

  def set_donantes
    self.donantes = Donante.ransack(filtro.condiciones).result
  end
end
