class Filtro < ApplicationRecord
  validates :parametros, presence: true

  def filtros
    parametros.map do |filtro|
      filtro["tipo"].constantize.new(**filtro.transform_keys(&:to_sym).excluding(:tipo))
    end
  end

  def aplicar
    query = Donante.all
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
