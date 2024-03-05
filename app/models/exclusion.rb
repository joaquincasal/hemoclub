class Exclusion < ApplicationRecord
  self.table_name = "exclusiones"

  belongs_to :donante

  validates :fecha_inicio, presence: true
  validates :fecha_fin, allow_nil: true, comparison: { greater_than: :fecha_inicio }
  validates :motivo, presence: true
end
