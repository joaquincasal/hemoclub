class Lista < ApplicationRecord
  has_one :filtro, dependent: :destroy

  validates :nombre, :filtro, presence: true
  accepts_nested_attributes_for :filtro

  validates :nombre, :filtro, presence: true

  def donantes(comunicacion = nil)
    filtro.aplicar(comunicacion)
  end
end
