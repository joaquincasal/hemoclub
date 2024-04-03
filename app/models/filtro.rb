class Filtro < ApplicationRecord
  validates :condiciones, presence: true
  belongs_to :lista_dinamica, optional: true # FIXME
end
