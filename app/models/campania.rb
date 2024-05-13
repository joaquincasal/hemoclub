class Campania < ApplicationRecord
  belongs_to :lista
  belongs_to :plantilla
  has_many :ejecuciones, as: :ejecutable, dependent: :destroy

  delegate :donantes, to: :lista

  validates :nombre, presence: true

  def enviar
    ejecucion = Ejecucion.create!(ejecutable: self)
    EnviarDifusionJob.perform_later(ejecucion.id)
  end
end
