class Filtro < ApplicationRecord
  validates :parametros, presence: true

  def filtros
    parametros.map do |filtro|
      filtro["tipo"].constantize.new(**filtro.transform_keys(&:to_sym).excluding(:tipo))
    end
  end

  def aplicar(comunicacion = nil)
    query = Donante.aptos
    if comunicacion
      ya_contactados = Interaccion
                       .where(comunicacion_id: comunicacion.id, donacion_id: Donante.pluck(:ultima_donacion_id))
                       .pluck(:donante_id)
      query = query.where.not(id: ya_contactados)
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
