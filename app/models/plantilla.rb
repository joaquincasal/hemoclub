class Plantilla < ApplicationRecord
  validates :nombre, :contenido, presence: true
  belongs_to :encabezado, optional: true, class_name: "Plantilla"
  belongs_to :firma, optional: true, class_name: "Plantilla"

  def contenido_completo
    (encabezado&.contenido || "") + contenido + (firma&.contenido || "")
  end

  def contenido_reemplazado(donante)
    reemplazar_variables(contenido_completo, donante.attributes)
  end

  private

  def reemplazar_variables(contenido, atributos)
    atributos.each { |atributo, valor| contenido.gsub!("{{#{atributo}}}", valor.to_s) }
    contenido.gsub!(/{{(.*?)}}/, '')
    contenido
  end
end
