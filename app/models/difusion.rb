class Difusion < ApplicationRecord
  belongs_to :lista
  belongs_to :plantilla
  has_many :ejecuciones, as: :ejecutable, dependent: :destroy
  has_many :interacciones, through: :ejecuciones

  delegate :donantes, to: :lista

  validates :nombre, presence: true

  def enviar
    ejecucion = Ejecucion.create!(ejecutable: self)
    EnviarDifusionJob.perform_later(ejecucion.id)
  end

  def programar_envio(fecha)
    donantes = lista.donantes
    ejecucion = Ejecucion.create!(ejecutable: self, donantes: donantes, fecha: fecha)
    EnviarDifusionJob.set(wait_until: fecha).perform_later(ejecucion.id)
  end
end
