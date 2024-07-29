class Clinica < ApplicationRecord
  has_many :donaciones, dependent: :nullify

  validates :codigo, uniqueness: true, presence: true
  validates :nombre, presence: true
end
