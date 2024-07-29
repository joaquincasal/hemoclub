FactoryBot.define do
  factory :automatizacion do
    nombre { "una automatizacion" }
    remitente { "sender@sender.com" }
    lista
    plantilla
  end
end
