# frozen_string_literal: true

class EnviarComunicacionJob < ApplicationJob
  def perform(ejecucion_id)
    ejecucion = Ejecucion.find(ejecucion_id)
    plantilla = ejecucion.comunicacion.plantilla
    donantes = ejecucion.comunicacion.donantes
    donantes.each { |donante| EnviarEmailJob.perform_later(plantilla.id, donante.id, ejecucion.id) }
    ejecucion.update(ejecutada: true)
  end
end
