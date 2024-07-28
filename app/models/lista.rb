class Lista < ApplicationRecord
  has_one :filtro, dependent: :destroy
  has_many :comunicaciones, dependent: :restrict_with_exception

  validates :nombre, :filtro, presence: true
  accepts_nested_attributes_for :filtro

  validates :nombre, :filtro, presence: true

  def donantes(comunicacion = nil)
    filtro.aplicar(comunicacion)
  end
end
