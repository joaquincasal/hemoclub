class Difusion < ApplicationRecord
  belongs_to :lista_dinamica
  belongs_to :plantilla

  validates :nombre, presence: true
end
