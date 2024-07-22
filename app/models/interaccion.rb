class Interaccion < ApplicationRecord
  belongs_to :donante
  belongs_to :ejecucion
  belongs_to :comunicacion

  enum estado_envio: [:entregado, :suprimido, :rebotado, :cuarentena, :filtrado, :expandido, :fallido]
  enum estado_interaccion: [:enviado, :leido]

  attribute :estado_interaccion, :integer, default: -> { estado_interacciones[:enviado] }

  def actualizar_estado_envio(estado)
    nuevo_estado = convertir_estado(estado)
    update(estado_envio: nuevo_estado)
    donante.desuscribir if nuevo_estado != estado_envios[:entregado]
  end

  def marcar_leido
    update(estado_interaccion: estado_interacciones[:leido])
  end

  private

  def convertir_estado(estado)
    mapper = {
      "Delivered" => estado_envios[:entregado],
      "Suppressed" => estado_envios[:suprimido],
      "Bounced" => estado_envios[:rebotado],
      "Quarantined" => estado_envios[:cuarentena],
      "FilteredSpam" => estado_envios[:filtrado],
      "Expanded" => estado_envios[:expandido],
      "Failed" => estado_envios[:fallido]
    }
    mapper.fetch(estado, nil)
  end
end
