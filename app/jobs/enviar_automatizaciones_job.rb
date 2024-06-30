# frozen_string_literal: true

class EnviarAutomatizacionesJob < ApplicationJob
  def perform
    Automatizacion.where(activa: true).find_each(&:enviar)
  end
end
