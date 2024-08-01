class Donante < ApplicationRecord
  attr_accessor :skip_uniqueness_validations

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
  enum grupo_sanguineo: [:"0", :A, :B, :AB, :A2B]
  enum factor: [:positivo, :negativo]

  validates :numero_documento, uniqueness: { scope: [:tipo_documento] }, allow_nil: false,
                               unless: -> { candidato? || skip_uniqueness_validations }
  validates :correo_electronico, uniqueness: true, allow_nil: true, format: { with: URI::MailTo::EMAIL_REGEXP },
                                 unless: -> { skip_uniqueness_validations }

  scope :sin_candidatos, -> { where(candidato: [false, nil]) }
  scope :candidatos, -> { where(candidato: true) }
  scope :predonantes, -> { where.not(predonante_plaquetas: [false, nil]) }
  scope :predonantes_aptos, -> { predonantes.where(motivo_rechazo_predonante_plaquetas: nil) }
  scope :predonantes_rechazados, -> { predonantes.where.not(motivo_rechazo_predonante_plaquetas: nil) }
  scope :del_club, -> { where(tipo_donante: tipo_donantes[:club]) }

  scope :con_email, -> { where.not(correo_electronico: nil) }
  scope :edad_apta, -> { where(fecha_nacimiento: [65.years.ago.., nil]) }
  scope :no_bloqueados, -> { where(bloqueado: [false, nil]) }
  scope :con_exclusiones, -> { joins(:exclusiones).where(exclusiones: { fecha_fin: [Time.current.., nil] }) }
  scope :serologia_reactiva, lambda {
    joins(:donaciones).where(donaciones: { serologia: [Donacion.serologia[:reactiva], nil] })
  }
  scope :con_donacion_rechazada, -> { joins(:ultima_donacion).where.not(ultima_donacion: { motivo_rechazo: nil }) }
  scope :contactados, ->(fecha) { joins(:ultima_donacion).where(ultima_donacion: { fecha: ..fecha }) }
  scope :aptos, lambda {
    con_email.edad_apta.sin_candidatos.no_bloqueados
             .where.not(id: con_exclusiones).where.not(id: serologia_reactiva).where.not(id: con_donacion_rechazada)
  }
  scope :para_informes, lambda {
    joins(:ultima_donacion).where(ultima_donacion: { fecha: 1.year.ago.. }).sin_candidatos
                           .where.not(id: serologia_reactiva).where.not(id: con_donacion_rechazada)
  }

  generates_token_for :suscripcion do
    suscripto
  end

  def nombre_completo
    [nombre, apellidos].compact_blank.join(" ")
  end

  def edad
    return nil if fecha_nacimiento.blank?

    ((Time.zone.now - fecha_nacimiento.to_time) / 1.year.seconds).floor
  end

  def suscribir
    update(suscripto: true)
  end

  def desuscribir
    update(suscripto: false)
  end

  def bloquear
    update(bloqueado: true)
  end
end
