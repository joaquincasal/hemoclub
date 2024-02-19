# frozen_string_literal: true

class ActualizarDonantesJob < ApplicationJob
  def perform
    donantes_del_club_activos = Donante.joins(:donaciones)
                                       .del_club
                                       .where(donaciones: { fecha: 1.year.ago.. })
                                       .distinct
                                       .pluck(:id)
    donantes_a_sacar = Donante.del_club.where.not(id: donantes_del_club_activos)
    donantes_a_sacar.update_all(tipo_donante: Donante.tipo_donantes[:voluntario])
  end
end
