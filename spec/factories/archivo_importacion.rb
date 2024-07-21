FactoryBot.define do
  factory :importacion, class: Hash do
    TipoDonante { "Voluntario" }
    FechaIng { "11/22/2022" }
    Nombre { "PÉREZ PABLO" }
    TipoDoc { "DNI" }
    NroDoc { "11222333" }
    Sexo { "M" }
    FechaNac { "5/14/1990" }
    Domicilio { "AV. CORRIENTES 900" }
    DomicilioObs { "" }
    CodPostal { "1234" }
    Localidad { "CAPITAL FEDERAL" }
    Provincia { "BUENOS AIRES" }
    Pais { "ARGENTINA" }
    Telefono { "4444-4444" }
    Email { "MAIL@MAIL.COM" }
    Ocupacion { "CONTADOR" }
    TipoDona { "Homóloga" }
    Relacionado { "No Relac." }
    Nuevo { "Nuevo" }
    Habitual { "No Habitual" }
    Rechazo { "" }
    PreDon { "" }
    PreDonRechazo { "" }
    Grupo { "0" }
    Rh { "+" }
    Serologia { "-" }
    TotalDonaciones { "5" }
    Fecha1Donacion { "12/29/2019" }
    Colecta { "" }
    CodInstOrigen { "" }
    CodClinica { "1" }
    CodIngreso { "99888777" }

    skip_create
    initialize_with { attributes }
  end

  trait :voluntario do
    TipoDonante { "Voluntario" }
  end

  trait :club do
    TipoDonante { "Club Donantes" }
  end

  trait :reposicion do
    TipoDonante { ".Común" }
  end

  trait :autologa do
    TipoDona { "Autólogo" }
  end

  trait :con_rechazo do
    Rechazo { "9" }
  end

  trait :predonante do
    PreDon { "P" }
  end

  trait :rechazo_predonante do
    PreDonRechazo { "1" }
  end

  trait :serologia_reactiva do
    Serologia { "R" }
  end

  trait :colecta do
    Colecta { "C" }
    CodInstOrigen { "99" }
    CodClinica { "99" }
  end

  trait :prestamo do
    CodInstOrigen { "77" }
  end
end
# frozen_string_literal: true
