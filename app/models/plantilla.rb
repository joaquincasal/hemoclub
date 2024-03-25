class Plantilla < ApplicationRecord
  validates :nombre, :contenido, presence: true
end
