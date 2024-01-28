class Donacion < ApplicationRecord
  self.table_name = "donaciones"

  belongs_to :donante
  belongs_to :clinica, optional: true

  validates :codigo_ingreso, uniqueness: true

  enum serologia: [:reactiva, :negativa]

  scope :no_rechazadas, -> { where(motivo_rechazo: nil) }
end
