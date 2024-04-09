class ListaDinamica < ApplicationRecord
  self.table_name = "listas_dinamicas"
  has_one :filtro, dependent: :destroy

  validates :nombre, :filtro, presence: true
  accepts_nested_attributes_for :filtro

  def donantes
    Donante.ransack(filtro.condiciones).result.includes(:donaciones).limit(10)
  end
end
