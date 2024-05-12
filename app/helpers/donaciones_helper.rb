module DonacionesHelper
  RECHAZO_MAPPER = {
    1 => "Alergia",
    2 => "Área endemica paludismo",
    3 => "Bajo nivel HB",
    4 => "Bajo peso",
    5 => "Bajo recuento plaquetas",
    6 => "Cx, Endosc,Tatuaje Ult 6 Meses",
    7 => "Donación previa antes 2 meses",
    8 => "Embarazo",
    9 => "Enfermedad preexistente",
    10 => "Exclusión grupo sanguíneo",
    11 => "Fuera de edad",
    12 => "Hipertensión",
    13 => "Hipotensión",
    14 => "MRV (Mala red venosa)",
    15 => "Se retira",
    16 => "Serología positiva anterior",
    17 => "Situación de riesgo",
    18 => "Tx o Cx previa Ult. 12 meses",
    19 => "Vacunación",
    20 => "Tratamiento odontológico",
    21 => "Anticuerpo positivo (Aferesis)",
    22 => "Prot. De Coronavirus",
    23 => "ZG"
  }

  def motivo_rechazo(numero_rechazo)
    return "" if numero_rechazo.blank?

    RECHAZO_MAPPER.fetch(numero_rechazo, "Otro")
  end
end
