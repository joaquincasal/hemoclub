class Filtro < ApplicationRecord
  validates :parametros, presence: true

  def filtros
    parametros.map do |filtro|
      filtro["tipo"].constantize.new(**filtro.transform_keys(&:to_sym).excluding(:tipo))
    end
  end

  def aplicar(id = nil)
    query = Donante.con_email.sin_exclusiones
    if id
      ya_contactados = Interaccion
                       .where(ejecutable_id: id, donacion_id: Donante.where.not(ultima_donacion_id: nil)
                                                                     .select(:ultima_donacion_id))
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
