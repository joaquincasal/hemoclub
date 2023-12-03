class Donante < ApplicationRecord
  validates :numero_documento, uniqueness: { scope: [:tipo_documento, :sexo] }
  validates :correo_electronico, uniqueness: true, allow_nil: true

  has_many :donaciones, dependent: :destroy

  before_validation :verificar_correo_electronico

  enum tipo_donante: [:reposicion, :voluntario, :club]
  enum tipo_documento: [:DNI, :CIE, :PAS, :DOC]
  enum sexo: [:masculino, :femenino]
  enum grupo_sanguineo: [:"0", :A, :B, :AB]
  enum factor: [:positivo, :negativo]

  def nombre_completo
    [nombre, apellidos].compact_blank.join(" ")
  end

  def edad
    return nil if fecha_nacimiento.blank?

    ((Time.zone.now - fecha_nacimiento.to_time) / 1.year.seconds).floor
  end

  private

  def verificar_correo_electronico
    self.correo_electronico = nil unless correo_electronico =~ URI::MailTo::EMAIL_REGEXP
  end
end
