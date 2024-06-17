class Plantilla < ApplicationRecord
  validates :nombre, :contenido, presence: true
  belongs_to :encabezado, optional: true, class_name: "Plantilla"
  belongs_to :firma, optional: true, class_name: "Plantilla"

  def contenido_completo
    texto = (encabezado&.contenido || "") + contenido + (firma&.contenido || "")
    ActionController::Base.helpers.sanitize(texto, attributes: %w[href target style])
  end

  def contenido_reemplazado(donante, enviar: false)
    texto = reemplazar_variables(contenido_completo, donante, enviar)
    ActionController::Base.helpers.sanitize(texto, attributes: %w[href target style])
  end

  def asunto_reemplazado(donante, enviar: false)
    texto = reemplazar_variables(asunto, donante, enviar)
    ActionController::Base.helpers.sanitize(texto, attributes: %w[href target style])
  end

  private

  def reemplazar_variables(texto, donante, enviar)
    reemplazar_variables_especiales(texto, donante, enviar)
    reemplazar_variables_donante(texto, donante.attributes)
    eliminar_variables(texto)
  end

  def reemplazar_variables_donante(texto, atributos)
    atributos.each { |atributo, valor| texto.gsub!("{{#{atributo}}}", valor.to_s) }
    texto
  end

  def eliminar_variables(texto)
    texto.gsub!(/{{(.*?)}}/, '')
    texto
  end

  def reemplazar_variables_especiales(texto, donante, enviar)
    reemplazar_variable_cantidad_donaciones(texto, donante)
    reemplazar_variable_fecha_ultima_donacion(texto, donante)
    reemplazar_variable_link_recordatorios(texto, donante, enviar)
  end

  def reemplazar_variable_cantidad_donaciones(texto, donante)
    texto.gsub!("{{cantidad_donaciones}}", donante.donaciones_count.to_s)
  end

  def reemplazar_variable_fecha_ultima_donacion(texto, donante)
    texto.gsub!("{{fecha_ultima_donacion}}", donante&.ultima_donacion&.fecha&.strftime("%d/%m/%Y") || "")
  end

  def reemplazar_variable_link_recordatorios(texto, donante, enviar)
    link = enviar ? link_recordatorios(donante) : ""
    texto.gsub!("{{link_recibir_recordatorios}}",
                "<a style='#{estilos_boton}' target='_blank' href='#{link}'>Quiero recibir recordatorios</a>")
  end

  def link_recordatorios(donante)
    token = donante.generate_token_for(:recordatorios)
    Rails.application.routes.url_helpers.recordatorios_donantes_url(token: token)
  end

  def estilos_boton
    "display: inline-block;outline: 0;border: 0;cursor: pointer;background-color: #f20707;border-radius: 50px;
    padding: 8px 16px;font-size: 16px;font-weight: 700;color: white;line-height: 26px;"
  end
end
