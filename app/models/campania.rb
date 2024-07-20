class Campania < ApplicationRecord
  belongs_to :lista
  belongs_to :plantilla
  has_many :ejecuciones, as: :ejecutable, dependent: :destroy
  has_many :interacciones, through: :ejecuciones

  delegate :donantes, to: :lista

  validates :nombre, presence: true

  def enviar
    ejecucion = Ejecucion.create!(ejecutable: self)
    EnviarCampaniaJob.perform_later(ejecucion.id)
  end

  def programar_envio(fecha)
    ejecucion = Ejecucion.create!(ejecutable: self, fecha: fecha)
    EnviarCampaniaJob.set(wait_until: fecha).perform_later(ejecucion.id)
  end
end
