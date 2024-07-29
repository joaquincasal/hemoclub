class FiltroPorAtributo
  def initialize(atributo:, operador:, valor:)
    @atributo = atributo
    @operador = operador
    @valor = valor
  end

  def descripcion
    "\"#{@atributo}\" es #{@operador} a \"#{descripcion_valor}\""
  end

  def aplicar
    validar_parametros!

    if self.class.valores(@atributo)["tipo"] == "lista"
      valor = self.class.valores(@atributo)["valores_query"][@valor]
    else
      valor = @valor
    end
    operador = Filtro::OPERADORES[@operador]

    if @atributo == "candidato"
      Donante.unscope(where: "donantes.#{@atributo}").where("donantes.#{@atributo} #{operador} ?", valor)
    else
      Donante.where("donantes.#{@atributo} #{operador} ?", valor)
    end
  end

  def self.nombre
    "Información del donante"
  end

  def self.nombre_parametro(orden)
    {
      1 => "Dato",
      2 => "Operador",
      3 => "Valor"
    }[orden].to_s
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
      "Está suscripto" => "suscripto",
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
      "suscripto" => { "tipo" => "boolean" },
      "donaciones_count" => { "tipo" => "number" }
    }[atributo]
  end

  def self.atributo?
    true
  end

  def self.operador?
    true
  end

  private

  def descripcion_valor
    if self.class.valores(@atributo)["tipo"] == "boolean"
      return ActiveModel::Type::Boolean.new.cast(@valor) ? "sí" : "no"
    end

    @valor
  end

  def validar_parametros!
    raise ArgumentError if self.class.atributos.values.exclude?(@atributo)
    raise ArgumentError if self.class.operadores(@atributo).values.exclude?(@operador)
  end
end
