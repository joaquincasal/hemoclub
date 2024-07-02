class ExclusionTipica < ApplicationRecord
  validates :duracion, presence: true, numericality: true
  validates :motivo, presence: true
end
