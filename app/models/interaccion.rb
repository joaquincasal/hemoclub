class Interaccion < ApplicationRecord
  belongs_to :donante
  belongs_to :ejecucion
  belongs_to :comunicacion

  enum estado_envio: [:entregado, :suprimido, :rebotado, :cuarentena, :filtrado, :expandido, :fallido]
  enum estado_interaccion: [:enviado, :leido]

  attribute :estado_interaccion, :integer, default: -> { estado_interacciones[:enviado] }

  def actualizar_estado_envio(estado)
    update(estado_envio: estado)
    donante.bloquear if estado != estado_envios[:entregado]
  end

  def marcar_leido
    update(estado_interaccion: estado_interacciones[:leido])
  end
end
