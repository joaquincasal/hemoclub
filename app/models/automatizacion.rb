class Automatizacion < Comunicacion
  scope :activa, -> { where(activa: true) }

  def filtrar_contactados?
    true
  end
end
