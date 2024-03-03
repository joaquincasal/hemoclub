class Donante < ApplicationRecord
  has_many :donaciones, dependent: :destroy

  enum tipo_donante: [:reposicion, :voluntario, :club]
  enum tipo_documento: [:DNI, :CIE, :PAS, :DOC]
  enum sexo: [:masculino, :femenino]
  enum grupo_sanguineo: [:"0", :A, :B, :AB]
  enum factor: [:positivo, :negativo]

  validates :numero_documento, uniqueness: { scope: [:tipo_documento] }, allow_nil: false
  validates :correo_electronico, uniqueness: true, allow_nil: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :predonantes, -> { where.not(predonante_plaquetas: nil) }
  scope :predonantes_aptos, -> { predonantes.where(motivo_rechazo_predonante_plaquetas: nil) }
  scope :predonantes_rechazados, -> { predonantes.where.not(motivo_rechazo_predonante_plaquetas: nil) }
  scope :del_club, -> { where(tipo_donante: tipo_donantes[:club]) }

  def nombre_completo
    [nombre, apellidos].compact_blank.join(" ")
  end

  def edad
    return nil if fecha_nacimiento.blank?

    ((Time.zone.now - fecha_nacimiento.to_time) / 1.year.seconds).floor
  end

  def self.ransackable_attributes(auth_object = nil)
    ["apellidos", "correo_electronico", "nombre", "numero_documento", "segundo_nombre", "tipo_donante"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["donaciones"]
  end
end
