class Donante < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :buscar,
                  against: [:apellidos, :nombre, :segundo_nombre, :numero_documento, :correo_electronico],
                  using: { tsearch: { prefix: true } }

  has_many :donaciones, dependent: :destroy
  belongs_to :ultima_donacion, class_name: "Donacion", optional: true
  has_many :exclusiones, dependent: :destroy
  has_many :interacciones, dependent: :destroy
  has_many :ejecuciones, through: :interacciones

  enum tipo_donante: [:reposicion, :voluntario, :club]
  enum tipo_documento: [:DNI, :CIE, :PAS, :DOC]
  enum sexo: [:masculino, :femenino]
  enum grupo_sanguineo: [:"0", :A, :B, :AB]
  enum factor: [:positivo, :negativo]

  validates :numero_documento, uniqueness: { scope: [:tipo_documento] }, allow_nil: false, unless: -> { candidato? }
  validates :correo_electronico, uniqueness: true, allow_nil: true
  validate :validar_correo_electronico

  scope :predonantes, -> { where.not(predonante_plaquetas: nil) }
  scope :predonantes_aptos, -> { predonantes.where(motivo_rechazo_predonante_plaquetas: nil) }
  scope :predonantes_rechazados, -> { predonantes.where.not(motivo_rechazo_predonante_plaquetas: nil) }
  scope :del_club, -> { where(tipo_donante: tipo_donantes[:club]) }
  scope :con_email, -> { where.not(correo_electronico: nil) }
  scope :edad_apta, -> { where(fecha_nacimiento: 65.years.ago..) }
  scope :con_exclusiones, -> { joins(:exclusiones).where(exclusiones: { fecha_fin: [Time.current.., nil] }) }
  scope :serologia_reactiva, lambda {
    joins(:donaciones).where(donaciones: { serologia: [Donacion.serologia[:reactiva], nil] })
  }
  scope :aptos, -> { con_email.edad_apta.where.not(id: con_exclusiones).where.not(id: serologia_reactiva) }

  generates_token_for :recordatorios do
    respondio_bienvenida
  end

  def nombre_completo
    [nombre, apellidos].compact_blank.join(" ")
  end

  def edad
    return nil if fecha_nacimiento.blank?

    ((Time.zone.now - fecha_nacimiento.to_time) / 1.year.seconds).floor
  end

  private

  def validar_correo_electronico
    return if correo_electronico.blank?

    self.correo_electronico = nil unless correo_electronico.match?(URI::MailTo::EMAIL_REGEXP)
  end
end
