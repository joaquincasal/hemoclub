# frozen_string_literal: true

class EnviarDifusionJob < ApplicationJob
  def perform(ejecucion_id)
    # Email.enviar
    Ejecucion.find(ejecucion_id).update(ejecutada: true)
  end
end
