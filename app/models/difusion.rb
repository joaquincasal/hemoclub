class Difusion < ApplicationRecord
  belongs_to :lista
  belongs_to :plantilla
  has_many :ejecuciones, as: :ejecutable, dependent: :destroy

  validates :nombre, presence: true

  def enviar
    donantes = lista.donantes
    ejecucion = Ejecucion.create!(ejecutable: self, donantes:)
    EnviarDifusionJob.perform_later(ejecucion.id)
  end

  def programar_envio(fecha)
    donantes = lista.donantes
    ejecucion = Ejecucion.create!(ejecutable: self, donantes:, fecha:)
    EnviarDifusionJob.set(wait_until: fecha).perform_later(ejecucion.id)
  end
end
