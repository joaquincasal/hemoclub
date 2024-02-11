class Donante < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :buscar,
                  against: [:apellidos, :nombre, :segundo_nombre, :numero_documento, :correo_electronico],
                  using: { tsearch: { prefix: true } }

  validates :numero_documento, uniqueness: { scope: [:tipo_documento] }, allow_nil: false
  validates :correo_electronico, uniqueness: true, allow_nil: true

  has_many :donaciones, dependent: :destroy

  before_validation :verificar_correo_electronico

  enum tipo_donante: [:reposicion, :voluntario, :club]
  enum tipo_documento: [:DNI, :CIE, :PAS, :DOC]
  enum sexo: [:masculino, :femenino]
  enum grupo_sanguineo: [:"0", :A, :B, :AB]
  enum factor: [:positivo, :negativo]

  scope :predonantes, -> { where.not(predonante_plaquetas: nil) }
  scope :predonantes_aptos, -> { predonantes.where(motivo_rechazo_predonante_plaquetas: nil) }
  scope :predonantes_rechazados, -> { predonantes.where.not(motivo_rechazo_predonante_plaquetas: nil) }

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
