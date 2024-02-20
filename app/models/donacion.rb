class Donacion < ApplicationRecord
  self.table_name = "donaciones"

  CODIGO_CLINICA_CLUB = 28
  CODIGO_CLINICA_VOLUNTARIOS = 29
  CODIGO_CLINICA_COLECTA = 99

  belongs_to :donante
  belongs_to :clinica, optional: true

  enum serologia: [:reactiva, :negativa]

  validates :fecha, uniqueness: { scope: [:donante_id] }, allow_nil: false

  scope :rechazadas, -> { where.not(motivo_rechazo: nil) }
  scope :no_rechazadas, -> { where(motivo_rechazo: nil) }

  def relacionado?
    [CODIGO_CLINICA_CLUB, CODIGO_CLINICA_VOLUNTARIOS, CODIGO_CLINICA_COLECTA].exclude?(clinica_id)
  end

  def colecta?
    clinica_id == CODIGO_CLINICA_COLECTA
  end

  def rechazada?
    motivo_rechazo.present?
  end

  def apta?
    !rechazada? && negativa?
  end
end
