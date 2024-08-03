# frozen_string_literal: true

class EnviarEmailError < StandardError; end

class EnviarEmailJob < ApplicationJob
  retry_on EnviarEmailError, wait: 1.day, attempts: 3

  def perform(plantilla_id, donante_id, ejecucion_id)
    ejecucion = Ejecucion.find(ejecucion_id)
    donante = Donante.find(donante_id)
    if ejecucion.comunicacion.filtrar_contactados? &&
       Interaccion.exists?(comunicacion_id: ejecucion.comunicacion_id, donacion_id: donante.ultima_donacion_id)
      return
    end

    plantilla = Plantilla.find(plantilla_id)
    id_mensaje = Mailer.new(donante, plantilla, ejecucion.comunicacion.remitente).enviar
    raise EnviarEmailError if id_mensaje.blank?

    Interaccion.create!(comunicacion: ejecucion.comunicacion, donante: donante, ejecucion: ejecucion,
                        id_mensaje: id_mensaje, fecha: Time.zone.now, donacion_id: donante.ultima_donacion_id,
                        estado_interaccion: Interaccion.estado_interacciones[:enviado])
  end
end
