class Comunicacion < ApplicationRecord
  belongs_to :lista
  belongs_to :plantilla
  has_many :ejecuciones, dependent: :destroy
  has_many :interacciones, through: :ejecuciones

  validates :nombre, presence: true

  def self.remitentes
    ENV.fetch("API_MAILER_SENDERS", "").split(",")
  end

  def enviar
    ejecucion = Ejecucion.create!(comunicacion: self)
    EnviarComunicacionJob.perform_later(ejecucion.id)
  end

  def donantes
    lista.donantes(self)
  end
end
