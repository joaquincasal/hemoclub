class FiltroPorUltimaDonacion
  attr_reader :atributo, :operador, :valor

  def initialize(atributo:, operador:, valor:)
    @atributo = atributo
    @operador = operador
    if self.class.valores(@atributo)["tipo"] == "lista"
      @valor = self.class.valores(@atributo)["valores_query"][valor]
    else
      @valor = valor
    end
  end

  def aplicar
    validar_parametros
    operador_query = Filtro::OPERADORES[operador]
    Donante.joins(:ultima_donacion).where("donaciones.#{atributo} #{operador_query} ?", valor)
  end

  def self.nombre
    "Información de la última donación"
  end

  def self.atributos
    {
      "Tipo de donante" => "tipo_donante",
      "Fecha" => "fecha"
    }
  end

  def self.operadores(atributo)
    if atributo == "fecha"
      {
        "Igual" => "igual",
        "Distinto" => "distinto",
        "Mayor" => "mayor",
        "Menor" => "menor",
        "Mayor o igual" => "mayor_o_igual",
        "Menor o igual" => "menor_o_igual"
      }
    else
      {
        "Igual" => "igual",
        "Distinto" => "distinto"
      }
    end
  end

  def self.valores(atributo)
    {
      "tipo_donante" => {
        "tipo" => "lista",
        "valores" => { "Reposicion" => "reposicion", "Voluntario" => "voluntario", "Club de donantes" => "club" },
        "valores_query" => { "reposicion" => Donante.tipo_donantes.key(Donante.tipo_donantes[:reposicion]),
                             "voluntario" => Donante.tipo_donantes.key(Donante.tipo_donantes[:voluntario]),
                             "club" => Donante.tipo_donantes.key(Donante.tipo_donantes[:club]) }
      },
      "fecha" => { "tipo" => "date" }
    }[atributo]
  end

  def self.nombre_dato(orden)
    {
      1 => "Dato",
      2 => "Operador",
      3 => "Valor"
    }[orden].to_s
  end

  private

  def validar_parametros
    raise ArgumentError if self.class.atributos.values.exclude?(@atributo)
    raise ArgumentError if self.class.operadores(@atributo).values.exclude?(@operador)
  end
end
