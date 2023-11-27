class Donacion < ApplicationRecord
  self.table_name = "donaciones"

  belongs_to :donante
  belongs_to :clinica, optional: true

  validates :codigo_ingreso, uniqueness: true

  enum serologia: [:reactiva, :negativa]
end
