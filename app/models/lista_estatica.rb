class ListaEstatica < Lista
  has_and_belongs_to_many :donantes

  def set_donantes
    # FIXME
    self.donantes = Donante.limit(1)
  end
end
