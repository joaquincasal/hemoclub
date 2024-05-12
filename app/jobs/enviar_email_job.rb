# frozen_string_literal: true

class EnviarEmailJob < ApplicationJob
  def perform(plantilla_id, donante_id)
    plantilla = Plantilla.find(plantilla_id)
    donante = Donante.find(donante_id)
    #Mailer.new(donante, plantilla).enviar
  end
end
