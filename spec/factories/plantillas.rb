FactoryBot.define do
  factory :plantilla do
    nombre { "una plantilla" }
    contenido { "<p>Contenido<p/>" }
    asunto { "Asunto" }
  end
end
