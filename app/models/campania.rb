class Campania < ApplicationRecord
  belongs_to :lista
  belongs_to :plantilla

  validates :nombre, presence: true
end
