class FiltroPorAtributo
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
    Donante.where("donantes.#{atributo} #{operador_query} ?", valor)
  end

  def self.nombre
    "Información del donante"
  end

  def self.atributos
    {
      "Tipo de donante" => "tipo_donante",
      "Sexo" => "sexo",
      "Grupo sanguíneo" => "grupo_sanguineo",
      "Factor sanguíneo" => "factor",
      "Código postal" => "codigo_postal",
      "Predonante de plaquetas" => "predonante_plaquetas",
      "Candidato" => "candidato",
      "Respondió mail de bienvenida" => "respondio_bienvenida",
      "Cantidad de donaciones" => "donaciones_count"
    }
  end

  def self.operadores(atributo)
    if atributo == "donaciones_count"
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
        "valores_query" => { "reposicion" => Donante.tipo_donantes[:reposicion],
                             "voluntario" => Donante.tipo_donantes[:voluntario],
                             "club" => Donante.tipo_donantes[:club] }
      },
      "sexo" => {
        "tipo" => "lista",
        "valores" => { "Masculino" => "masculino", "Femenino" => "femenino" },
        "valores_query" => { "masculino" => Donante.sexos[:masculino], "femenino" => Donante.sexos[:femenino] }
      },
      "grupo_sanguineo" => {
        "tipo" => "lista",
        "valores" => { "0" => "0", "A" => "A", "B" => "B", "AB" => "AB" },
        "valores_query" => { "0" => Donante.grupo_sanguineos[:"0"], "A" => Donante.grupo_sanguineos[:A],
                             "B" => Donante.grupo_sanguineos[:B], "AB" => Donante.grupo_sanguineos[:AB] }
      },
      "factor" => {
        "tipo" => "lista",
        "valores" => { "Positivo" => "positivo", "Negativo" => "negativo" },
        "valores_query" => { "positivo" => Donante.factores[:positivo], "negativo" => Donante.factores[:negativo] }
      },
      "codigo_postal" => { "tipo" => "string" },
      "predonante_plaquetas" => { "tipo" => "boolean" },
      "candidato" => { "tipo" => "boolean" },
      "respondio_bienvenida" => { "tipo" => "boolean" },
      "donaciones_count" => { "tipo" => "number" }
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
