# frozen_string_literal: true

class EnviarEmailJob < ApplicationJob
  def perform(plantilla_id, donante_id, ejecucion_id)
    plantilla = Plantilla.find(plantilla_id)
    donante = Donante.find(donante_id)
    ejecucion = Ejecucion.find(ejecucion_id)
    id_mensaje = Mailer.new(donante, plantilla, ejecucion.ejecutable.remitente).enviar
    Interaccion.create!(ejecutable: ejecucion.ejecutable, donante: donante, ejecucion: ejecucion,
                        id_mensaje: id_mensaje, fecha: Time.zone.now)
  end
end
