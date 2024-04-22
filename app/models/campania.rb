class Campania < ApplicationRecord
  belongs_to :lista
  belongs_to :plantilla
  has_many :ejecuciones, as: :ejecutable, dependent: :destroy

  validates :nombre, presence: true

  def enviar
    donantes = lista.donantes
    ejecucion = Ejecucion.create!(ejecutable: self, donantes:)
    EnviarCampaniaJob.perform_later(ejecucion.id)
  end
end
