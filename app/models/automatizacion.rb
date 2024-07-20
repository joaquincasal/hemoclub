class Automatizacion < Comunicacion
  scope :activa, -> { where(activa: true) }
end
