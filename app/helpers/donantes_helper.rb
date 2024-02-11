module DonantesHelper
  include Pagy::Frontend

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

  def mostrar_booleano(valor)
    valor ? "Sí" : "No"
  end

  def link_orden(etiqueta, columna, **)
    if params[:orden] == columna.to_s
      direccion = params[:direccion] == "desc" ? "asc" : "desc"
    else
      direccion = "desc"
    end

    link = link_to(etiqueta, request.params.merge(orden: columna, direccion:), **)

    if params[:orden] == columna.to_s
      icon = "<span class='icon'><i class='fa fa-arrow-%s'></i></span>".html_safe
      if params[:direccion] == "desc"
        icon %= "down"
      else
        icon %= "up"
      end
    end

    safe_join([link, icon])
  end
end
