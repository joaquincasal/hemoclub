class Plantilla < ApplicationRecord
  validates :nombre, :contenido, presence: true
  belongs_to :encabezado, optional: true, class_name: "Plantilla"
  belongs_to :firma, optional: true, class_name: "Plantilla"
  has_many :comunicaciones, dependent: :restrict_with_exception

  scope :reutilizable, -> { where(reutilizable: true) }
  scope :para_email, -> { where(reutilizable: false) }

  def contenido_completo
    texto = (encabezado&.contenido || "") + contenido + (firma&.contenido || "")
    ActionController::Base.helpers.sanitize(texto, attributes: %w[src href target style height width alt])
  end

  def contenido_reemplazado(donante, enviar: false)
    texto = reemplazar_variables(contenido_completo, donante, enviar)
    ActionController::Base.helpers.sanitize(texto, attributes: %w[src href target style height width alt])
  end

  def asunto_reemplazado(donante, enviar: false)
    texto = reemplazar_variables(asunto, donante, enviar)
    ActionController::Base.helpers.sanitize(texto, attributes: %w[src href target style height width alt])
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
    reemplazar_variable_link_suscribir(texto, donante, enviar)
    reemplazar_variable_desuscribir(texto, donante, enviar)
  end

  def reemplazar_variable_cantidad_donaciones(texto, donante)
    texto.gsub!("{{cantidad_donaciones}}", donante.donaciones_count.to_s)
  end

  def reemplazar_variable_fecha_ultima_donacion(texto, donante)
    texto.gsub!("{{fecha_ultima_donacion}}", donante&.ultima_donacion&.fecha&.strftime("%d/%m/%Y") || "")
  end

  def reemplazar_variable_link_suscribir(texto, donante, enviar)
    link = enviar ? link_suscripcion(donante, true) : ""
    texto.gsub!("{{link_recibir_recordatorios}}",
                "<a style='#{estilos_boton_suscribir}' target='_blank' href='#{link}'>Quiero recibir recordatorios</a>")
  end

  def reemplazar_variable_desuscribir(texto, donante, enviar)
    link = enviar ? link_suscripcion(donante, false) : ""
    texto.gsub!("{{link_desuscribir}}",
                "<a style='#{estilos_boton_desuscribir}' target='_blank' href='#{link}'>Desuscribirme</a>")
  end

  def link_suscripcion(donante, valor)
    token = donante.generate_token_for(:suscripcion)
    Rails.application.routes.url_helpers.suscripcion_donantes_url(token: token, suscripcion: valor)
  end

  def estilos_boton_suscribir
    "display: inline-block;outline: 0;border: 0;cursor: pointer;background-color: #f20707;border-radius: 50px;
    padding: 8px 16px;font-size: 16px;font-weight: 700;color: white;line-height: 26px;"
  end

  def estilos_boton_desuscribir
    "display: inline-block;outline: 0;border: 0;cursor: pointer;background-color: #d6cbcb;border-radius: 50px;
    padding: 4px 8px;font-size: 12px;font-weight: 700;color: black;line-height: 26px;"
  end
end
