# frozen_string_literal: true

class EnviarEmailJob < ApplicationJob
  def perform(plantilla_id, donante_id, ejecucion_id)
    plantilla = Plantilla.find(plantilla_id)
    donante = Donante.find(donante_id)
    ejecucion = Ejecucion.find(ejecucion_id)
    id_mensaje = Mailer.new(donante, plantilla, ejecucion.comunicacion.remitente).enviar
    return if id_mensaje.blank?

    Interaccion.create!(comunicacion: ejecucion.comunicacion, donante: donante, ejecucion: ejecucion,
                        id_mensaje: id_mensaje, fecha: Time.zone.now, donacion_id: donante.ultima_donacion_id)
  end
end
