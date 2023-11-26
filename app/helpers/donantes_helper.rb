module DonantesHelper
  def direccion_completa(direccion, localidad, provincia, pais, codigo_postal)
    resultado = [direccion, localidad, provincia, pais].compact_blank.join(", ")
    resultado += " (CP: #{codigo_postal})" if codigo_postal.present?
    resultado
  end

  def fecha_ultima_donacion(donante)
    localize(donante.donaciones.max_by(&:fecha)&.fecha)
  end

  def tipo_donante(tipo)
    {
      "club" => "Club de donantes",
      "voluntario" => "Voluntario",
      "reposicion" => "Reposición"
    }[tipo]
  end

  def grupo_y_factor(grupo, factor)
    factor_mapper = { "positivo" => "+", "negativo" => "-" }
    "#{grupo}#{factor_mapper[factor]}"
  end
end
