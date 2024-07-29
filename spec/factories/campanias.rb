FactoryBot.define do
  factory :campania do
    nombre { "una campaña" }
    remitente { "sender@sender.com" }
    lista
    plantilla
  end
end
