class Interaccion < ApplicationRecord
  belongs_to :donante
  belongs_to :ejecucion

  enum estado_envio: [:entregado, :suprimido, :rebotado, :cuarentena, :filtrado, :expandido, :fallido]
  enum estado_interaccion: [:enviado, :leido]
end
