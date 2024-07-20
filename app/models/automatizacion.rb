class Automatizacion < ApplicationRecord
  belongs_to :lista
  belongs_to :plantilla
  has_many :ejecuciones, as: :ejecutable, dependent: :destroy
  has_many :interacciones, through: :ejecuciones

  delegate :donantes, to: :lista

  validates :nombre, presence: true

  scope :activa, -> { where(activa: true) }

  def enviar
    ejecucion = Ejecucion.create!(ejecutable: self)
    EnviarAutomatizacionJob.perform_later(ejecucion.id)
  end
end
