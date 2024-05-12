# frozen_string_literal: true

class EnviarDifusionJob < ApplicationJob
  def perform(ejecucion_id)
    ejecucion = Ejecucion.find(ejecucion_id)
    plantilla = ejecucion.ejecutable.plantilla
    ejecucion.donantes.each { |donante| EnviarEmailJob.perform_later(plantilla.id, donante.id) }
    ejecucion.update(ejecutada: true)
  end
end
