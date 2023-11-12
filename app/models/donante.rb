class Donante < ApplicationRecord
  validates :apellidos, :nombre, :tipo_documento, :numero_documento, :sexo, :fecha_nacimiento, presence: true
  validates :numero_documento, uniqueness: { scope: [:tipo_documento, :sexo] }
  validates :correo_electronico, uniqueness: true, allow_nil: true

  has_many :donaciones, dependent: :destroy

  before_validation :verificar_correo_electronico

  enum tipo_donante: [:reposicion, :voluntario, :club]
  enum tipo_documento: [:DNI, :CIE, :PAS, :DOC]
  enum sexo: [:masculino, :femenino]
  enum grupo_sanguineo: [:A, :B, :"0"]
  enum factor: [:positivo, :negativo]

  private

  def verificar_correo_electronico
    self.correo_electronico = nil unless correo_electronico =~ URI::MailTo::EMAIL_REGEXP
  end
end
