# frozen_string_literal: true

class EnviarEmailJob < ApplicationJob
  def perform(plantilla_id, donante_id, ejecucion_id)
    Plantilla.find(plantilla_id)
    donante = Donante.find(donante_id)
    ejecucion = Ejecucion.find(ejecucion_id)
    id_mensaje = "1234"
    # id_mensaje = Mailer.new(donante, plantilla).enviar
    Interaccion.create!(ejecutable: ejecucion.ejecutable, donante:, ejecucion:,
                        id_mensaje:, fecha: Time.zone.now)
  end
end
