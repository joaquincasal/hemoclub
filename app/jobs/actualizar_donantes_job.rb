# frozen_string_literal: true

class ActualizarDonantesJob < ApplicationJob
  def perform
    donantes_a_sacar = Donante.joins(:ultima_donacion)
                              .del_club
                              .where(ultima_donacion: { fecha: ..1.year.ago })
    donantes_a_sacar.update_all(tipo_donante: Donante.tipo_donantes[:voluntario])
  end
end
