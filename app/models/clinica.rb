class Clinica < ApplicationRecord
  has_many :donaciones, dependent: :nullify

  validates :codigo, uniqueness: true
end
