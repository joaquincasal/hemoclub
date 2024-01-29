# frozen_string_literal: true

require 'csv'
require 'tempfile'

class Importador
  TIPO_DONANTE_HEADER = "TipoDonante"
  FECHA_DONACION_HEADER = "FechaIng"
  NOMBRE_HEADER = "Nombre"
  TIPO_DOCUMENTO_HEADER = "TipoDoc"
  NUMERO_DOCUMENTO_HEADER = "NroDoc"
  SEXO_HEADER = "Sexo"
  FECHA_NACIMIENTO_HEADER = "FechaNac"
  DOMICILIO_HEADER = "Domicilio"
  DOMICILIO_OBS_HEADER = "DomicilioObs"
  CODIGO_POSTAL_HEADER = "CodPostal"
  LOCALIDAD_HEADER = "Localidad"
  PROVINCIA_HEADER = "Provincia"
  PAIS_HEADER = "Pais"
  TELEFONO_HEADER = "Telefono"
  EMAIL_HEADER = "Email"
  OCUPACION_HEADER = "Ocupacion"
  TIPO_DONACION_HEADER = "TipoDona"
  RELACIONADO_HEADER = "Relacionado"
  NUEVO_HEADER = "Nuevo"
  HABITUAL_HEADER = "Habitual"
  RECHAZO_HEADER = "Rechazo"
  PRE_DONANTE_HEADER = "PreDon"
  PRE_DONANTE_RECHAZO_HEADER = "PreDonRechazo"
  GRUPO_HEADER = "Grupo"
  RH_HEADER = "Rh"
  SEROLOGIA_HEADER = "Serologia"
  TOTAL_DONACIONES_HEADER = "TotalDonaciones"
  FECHA_PRIMERA_DONACION_HEADER = "Fecha1Donacion"
  COLECTA_HEADER = "Colecta"
  INSTITUCION_ORIGEN_HEADER = "CodInstOrigen"
  CODIGO_CLINICA_HEADER = "CodClinica"
  CODIGO_INGRESO_HEADER = "CodIngreso"

  TIPO_DONANTE_VOLUNTARIO = "Voluntario"
  TIPO_DONANTE_CLUB = "Club Donantes"
  DONACION_AUTOLOGA = "Autólogo"
  INSTITUCION_ORIGEN_COLECTA = "99"
  CODIGO_CLINICA_CLUB = "28"
  CODIGO_CLINICA_VOLUNTARIO = "29"
  COLECTA = "C"

  TRANSFORMACIONES_KEYS_DONANTE = {
    TIPO_DONANTE_HEADER => "tipo_donante",
    TIPO_DOCUMENTO_HEADER => "tipo_documento",
    NUMERO_DOCUMENTO_HEADER => "numero_documento",
    SEXO_HEADER => "sexo",
    FECHA_NACIMIENTO_HEADER => "fecha_nacimiento",
    DOMICILIO_HEADER => "direccion",
    CODIGO_POSTAL_HEADER => "codigo_postal",
    LOCALIDAD_HEADER => "localidad",
    PROVINCIA_HEADER => "provincia",
    PAIS_HEADER => "pais",
    TELEFONO_HEADER => "telefono",
    EMAIL_HEADER => "correo_electronico",
    OCUPACION_HEADER => "ocupacion",
    PRE_DONANTE_HEADER => "predonante_plaquetas",
    PRE_DONANTE_RECHAZO_HEADER => "motivo_rechazo_predonante_plaquetas",
    GRUPO_HEADER => "grupo_sanguineo",
    RH_HEADER => "factor"
  }.freeze

  TRANSFORMACIONES_VALORES_DONANTE = {
    TIPO_DONANTE_HEADER => {
      ".Común" => "reposicion",
      "Común" => "reposicion",
      "Acepta LLamado" => "reposicion",
      "Club Donantes" => "club",
      "Voluntario" => "voluntario"
    },
    SEXO_HEADER => {
      "M" => "masculino",
      "F" => "femenino"
    },
    RH_HEADER => {
      "+" => "positivo",
      "-" => "negativo"
    }
  }.freeze

  TRANSFORMACIONES_KEYS_DONACION = {
    FECHA_DONACION_HEADER => "fecha",
    RELACIONADO_HEADER => "relacionado",
    RECHAZO_HEADER => "motivo_rechazo",
    SEROLOGIA_HEADER => "serologia",
    COLECTA_HEADER => "colecta",
    CODIGO_CLINICA_HEADER => "clinica_id",
    CODIGO_INGRESO_HEADER => "codigo_ingreso"
  }.freeze

  TRANSFORMACIONES_VALORES_DONACION = {
    SEROLOGIA_HEADER => {
      "R" => "reactiva",
      "-" => "negativa"
    }
  }.freeze

  DONANTE_HEADERS = [TIPO_DONANTE_HEADER, NOMBRE_HEADER, TIPO_DOCUMENTO_HEADER, NUMERO_DOCUMENTO_HEADER, SEXO_HEADER,
                     FECHA_NACIMIENTO_HEADER, DOMICILIO_HEADER, CODIGO_POSTAL_HEADER, LOCALIDAD_HEADER,
                     PROVINCIA_HEADER, PAIS_HEADER, TELEFONO_HEADER, EMAIL_HEADER, OCUPACION_HEADER, PRE_DONANTE_HEADER,
                     PRE_DONANTE_RECHAZO_HEADER, GRUPO_HEADER, RH_HEADER].freeze
  DONACION_HEADERS = [FECHA_DONACION_HEADER, RELACIONADO_HEADER, RECHAZO_HEADER, SEROLOGIA_HEADER, COLECTA_HEADER,
                      CODIGO_CLINICA_HEADER, CODIGO_INGRESO_HEADER].freeze

  def importar(path_csv)
    filas_con_errores = realizar_importacion(path_csv)
    return true if filas_con_errores.empty?

    guardar_errores(filas_con_errores)
    false
  end

  private

  def guardar_errores(filas_con_errores)
    headers = filas_con_errores.first.headers.join(',')
    errores = filas_con_errores.map(&:to_csv)
    contenido_archivo = "#{headers}\n#{errores.join("\n")}"
    Rails.root.join("errores.csv").write(contenido_archivo)
  end

  def realizar_importacion(path_csv)
    filas_con_errores = []
    CSV.foreach(path_csv, headers: true) do |fila|
      fila_hash = fila.to_h.transform_values { |value| value&.strip }
      next if saltear_importacion?(fila_hash)

      solucionar_discrepancias!(fila_hash)
      donante = crear_o_actualizar_donante(fila_hash)
      crear_donacion(fila_hash, donante)
    rescue StandardError => e
      fila['error'] = e.message
      filas_con_errores.push(fila)
    end
    filas_con_errores
  end

  def saltear_importacion?(fila)
    es_donacion_autologa = fila[TIPO_DONACION_HEADER] == DONACION_AUTOLOGA
    institucion_origen = fila[INSTITUCION_ORIGEN_HEADER]
    es_prestamo = institucion_origen.present? && institucion_origen != INSTITUCION_ORIGEN_COLECTA
    es_donacion_autologa || es_prestamo
  end

  def solucionar_discrepancias!(fila)
    solucionar_discrepancia_tipo_donante_y_codigo_clinica!(fila)
    solucionar_discrepancia_tipo_donante_y_colecta!(fila)
  end

  def solucionar_discrepancia_tipo_donante_y_codigo_clinica!(fila)
    codigo_clinica = fila[CODIGO_CLINICA_HEADER]
    tipo_donante = fila[TIPO_DONANTE_HEADER]
    if codigo_clinica == CODIGO_CLINICA_CLUB && tipo_donante != TIPO_DONANTE_CLUB
      fila[TIPO_DONANTE_HEADER] = TIPO_DONANTE_CLUB
    elsif codigo_clinica == CODIGO_CLINICA_VOLUNTARIO && tipo_donante != TIPO_DONANTE_VOLUNTARIO
      fila[TIPO_DONANTE_HEADER] = TIPO_DONANTE_VOLUNTARIO
    end
  end

  def solucionar_discrepancia_tipo_donante_y_colecta!(fila)
    colecta = fila[COLECTA_HEADER]
    tipo_donante = fila[TIPO_DONANTE_HEADER]
    return unless colecta == COLECTA && [TIPO_DONANTE_CLUB, TIPO_DONANTE_VOLUNTARIO].exclude?(tipo_donante)

    fila[TIPO_DONANTE_HEADER] = TIPO_DONANTE_VOLUNTARIO
  end

  def crear_o_actualizar_donante(fila)
    campos_donante = campos_donante(fila)
    donante_existente = buscar_donante_existente(campos_donante)
    if donante_existente.present?
      donante_existente.update!(campos_donante)
      donante_existente
    else
      Donante.create!(campos_donante)
    end
  end

  def buscar_donante_existente(campos_donante)
    donante_existente_por_email = Donante.where.not(correo_electronico: nil)
                                         .find_by(correo_electronico: campos_donante["correo_electronico"])
    donante_existente_por_documento = Donante.find_by(numero_documento: campos_donante["numero_documento"],
                                                      tipo_documento: campos_donante["tipo_documento"],
                                                      sexo: campos_donante["sexo"])
    donante_existente_por_documento.presence || donante_existente_por_email.presence
  end

  def crear_donacion(fila, donante)
    campos_donacion = campos_donacion(fila).merge(donante:)
    Donacion.create!(campos_donacion)
  end

  def campos_donante(fila)
    campos = filtrar_campos(fila, DONANTE_HEADERS)
    separar_nombre_donante!(campos)
    convertir_fecha!(campos, FECHA_NACIMIENTO_HEADER, '%m/%d/%Y')
    transformar_valores!(campos, TRANSFORMACIONES_VALORES_DONANTE)
    transformar_keys!(campos, TRANSFORMACIONES_KEYS_DONANTE)
    borrar_vacios!(campos)
    campos
  end

  def campos_donacion(fila)
    campos = filtrar_campos(fila, DONACION_HEADERS)
    convertir_fecha!(campos, FECHA_DONACION_HEADER, '%d/%m/%Y')
    transformar_valores!(campos, TRANSFORMACIONES_VALORES_DONACION)
    transformar_keys!(campos, TRANSFORMACIONES_KEYS_DONACION)
    borrar_vacios!(campos)
    campos
  end

  def filtrar_campos(fila, mapper)
    fila.filter { |header, _| mapper.include?(header) }
  end

  def transformar_keys!(campos, mapper)
    campos.transform_keys!(mapper)
  end

  def transformar_valores!(campos, mapper)
    mapper.each { |header, valores| campos[header] = valores[campos[header]] }
  end

  def separar_nombre_donante!(campos)
    nombre_original = campos.delete(NOMBRE_HEADER)
    apellido, nombre, segundo_nombre = nombre_original.split
    campos["apellidos"] = apellido
    campos["nombre"] = nombre
    campos["segundo_nombre"] = segundo_nombre
  end

  def convertir_fecha!(campos, fecha_key, formato)
    campos[fecha_key] = Date.strptime(campos[fecha_key], formato)
  end

  def borrar_vacios!(campos)
    campos.reject! { |_, valor| valor.nil? || valor == "" }
  end
end
