# frozen_string_literal: true

class Mailer
  API_URL = ENV.fetch("API_MAILER_URL", nil)
  ENDPOINT = ENV.fetch("API_MAILER_ENDPOINT", nil)
  SECRET = ENV.fetch("API_MAILER_SECRET", nil)

  def initialize(donante, plantilla, remitente)
    @email_destinatario = donante.correo_electronico
    @nombre_destinatario = donante.nombre_completo
    @asunto = plantilla.asunto_reemplazado(donante, enviar: true)
    @cuerpo_email = plantilla.contenido_reemplazado(donante, enviar: true)
    @remitente = remitente
  end

  def enviar
    body = generar_body
    token = generar_token(body)
    headers = {
      "Content-Type" => "application/json",
      "x-ms-date" => token[:ahora],
      "host" => token[:host],
      "x-ms-content-sha256" => token[:body_digest],
      "Authorization" => token[:token]
    }
    response = HTTParty.post(API_URL + ENDPOINT, body: body.to_json, headers: headers)
    response.success? ? response["id"] : false
  end

  private

  def generar_body
    body = {}
    body["content"] = {
      html: @cuerpo_email,
      subject: @asunto
    }
    body["recipients"] = {
      to: [{ address: @email_destinatario, displayName: @nombre_destinatario }]
    }
    body["senderAddress"] = @remitente
    body
  end

  def generar_token(body)
    endpoint = ENDPOINT
    host = API_URL.gsub("https://", "")
    secret = SECRET
    ahora = Time.now.utc.httpdate

    body_digest = Digest::SHA256.base64digest(body.to_json)
    a_firmar = "POST\n#{endpoint}\n#{ahora};#{host};#{body_digest}"
    firma = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), Base64.decode64(secret),
                                                 a_firmar)).strip

    token = "HMAC-SHA256 SignedHeaders=x-ms-date;host;x-ms-content-sha256&Signature=#{firma}"

    { token: token, ahora: ahora, body_digest: body_digest, host: host }
  end
end
