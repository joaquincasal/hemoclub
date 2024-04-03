class Filtro < ApplicationRecord
  validates :condiciones, presence: true
  belongs_to :lista_dinamica
end
