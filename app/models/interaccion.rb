class Interaccion < ApplicationRecord
  belongs_to :donante
  belongs_to :ejecucion
  belongs_to :comunicacion
  belongs_to :donacion, optional: true

  validates :fecha, presence: true

  enum :estado_envio, [:entregado, :suprimido, :rebotado, :cuarentena, :filtrado, :expandido, :fallido]
  enum :estado_interaccion, [:enviado, :leido]

  scope :contactos_ultimas_donaciones, lambda { |comunicacion|
    where(comunicacion_id: comunicacion.id, donacion_id: Donante.pluck(:ultima_donacion_id))
  }

  def actualizar_estado_envio(estado)
    update(estado_envio: estado)
    donante.bloquear if estado != self.class.estado_envios[:entregado]
  end

  def marcar_leido
    update(estado_interaccion: self.class.estado_interacciones[:leido])
  end
end
