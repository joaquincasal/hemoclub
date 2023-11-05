class Donante < ApplicationRecord
  validates :apellidos, :nombre, :tipo_documento, :numero_documento, :sexo, :fecha_nacimiento, presence: true
end
