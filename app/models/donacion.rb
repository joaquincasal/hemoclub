class Donacion < ApplicationRecord
  self.table_name = "donaciones"

  belongs_to :donante
  belongs_to :clinica, optional: true

  validates :codigo_ingreso, uniqueness: true

  enum serologia: [:reactiva, :negativa]

  scope :rechazadas, -> { where.not(motivo_rechazo: nil) }
  scope :no_rechazadas, -> { where(motivo_rechazo: nil) }
end
