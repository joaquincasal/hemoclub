class Filtro < ApplicationRecord
  FECHA_INICIO_CONTACTOS = Date.parse(ENV.fetch("FECHA_INICIO_CONTACTO", "2024-09-01"))

  validates :parametros, presence: true

  def filtros
    parametros.map do |filtro|
      filtro["tipo"].constantize.new(**filtro.transform_keys(&:to_sym).excluding(:tipo))
    end
  end

  def aplicar(comunicacion = nil)
    query = Donante.aptos
    if comunicacion.present? && comunicacion.filtrar_contactados?
      contactados = Interaccion.contactos_ultimas_donaciones(comunicacion).pluck(:donante_id)
      contactados_salesforce = Donante.contactados(FECHA_INICIO_CONTACTOS)
      query = query.where.not(id: contactados).where.not(id: contactados_salesforce)
    end
    filtros.each do |filtro|
      query.merge!(filtro.aplicar)
    end
    query
  end

  OPERADORES = {
    "igual" => "=",
    "distinto" => "!=",
    "mayor" => ">",
    "menor" => "<",
    "mayor_o_igual" => ">=",
    "menor_o_igual" => "<="
  }.freeze
end
