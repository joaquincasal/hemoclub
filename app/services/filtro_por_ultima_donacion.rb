class FiltroPorUltimaDonacion
  def initialize(atributo:, operador:, valor:)
    @atributo = atributo
    @operador = operador
    @valor = valor
  end

  def descripcion
    "\"#{@atributo}\" de la última donación es #{@operador} a \"#{descripcion_valor}\""
  end

  def aplicar
    validar_parametros!

    valor = self.class.valores(@atributo)["valores_query"][@valor]
    operador = Filtro::OPERADORES[@operador]

    Donante.joins(:ultima_donacion).where("donaciones.#{@atributo} #{operador} ?", valor)
  end

  def self.nombre
    "Información de la última donación"
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
      "Fecha" => "fecha"
    }
  end

  def self.operadores(atributo)
    if atributo == "fecha"
      {
        "Igual" => "igual",
        "Distinto" => "distinto",
        "Hace más de" => "menor",
        "Hace menos de" => "mayor"
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
      "fecha" => {
        "tipo" => "lista",
        "valores" => { "Hoy" => "0", "1 mes" => "1", "2 meses" => "2", "3 meses" => "3", "4 meses" => "4",
                       "5 meses" => "5", "6 meses" => "6", "7 meses" => "7", "8 meses" => "8", "9 meses" => "9",
                       "10 meses" => "10", "11 meses" => "11", "12 meses" => "12" },
        "valores_query" => { "0" => 0.months.ago, "1" => 1.month.ago, "2" => 2.months.ago, "3" => 3.months.ago,
                             "4" => 4.months.ago, "5" => 5.months.ago, "6" => 6.months.ago, "7" => 7.months.ago,
                             "8" => 8.months.ago, "9" => 9.months.ago, "10" => 10.months.ago, "11" => 11.months.ago,
                             "12" => 12.months.ago }
      }
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
    return "#{@valor} meses" if @atributo == "fecha"

    @valor
  end

  def validar_parametros!
    raise ArgumentError if self.class.atributos.values.exclude?(@atributo)
    raise ArgumentError if self.class.operadores(@atributo).values.exclude?(@operador)
  end
end
