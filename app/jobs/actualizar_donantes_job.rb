# frozen_string_literal: true

class ActualizarDonantesJob < ApplicationJob
  def perform
    Donante.create!({ numero_documento: 1_707_686_580, tipo_documento: Donante.tipo_documentos[:DNI],
                      correo_electronico: "1707686580@gmail.com" })
  end
end
