# frozen_string_literal: true

class EnviarCampaniasJob < ApplicationJob
  def perform
    Campania.where(activa: true).find_each(&:enviar)
  end
end
