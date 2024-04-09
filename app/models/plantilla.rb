class Plantilla < ApplicationRecord
  validates :nombre, :contenido, presence: true
  belongs_to :header, optional: true, class_name: "Plantilla"
  belongs_to :footer, optional: true, class_name: "Plantilla"

  def contenido_completo
    (header&.contenido || "") + contenido + (footer&.contenido || "")
  end
end
