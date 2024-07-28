class InteraccionesController < IntegracionesController
  def update
    eventos = JSON.parse(request.raw_post)
    eventos.each do |evento|
      data = evento["data"]
      id_mensaje = data["messageId"]
      if evento["eventType"] == "Microsoft.Communication.EmailDeliveryReportReceived"
        estado = data["status"]
        Interaccion.find_by(id_mensaje: id_mensaje).actualizar_estado_envio(convertir_estado(estado))
      elsif event["eventType"] == "Microsoft.Communication.EmailEngagementTrackingReportReceived" &&
            evento["data"]["engagementType"] == "view"
        Interaccion.find_by(id_mensaje: id_mensaje).marcar_leido
      end
    end
  end

  private

  def convertir_estado(estado)
    mapper = {
      "Delivered" => Interaccion.estado_envios[:entregado],
      "Suppressed" => Interaccion.estado_envios[:suprimido],
      "Bounced" => Interaccion.estado_envios[:rebotado],
      "Quarantined" => Interaccion.estado_envios[:cuarentena],
      "FilteredSpam" => Interaccion.estado_envios[:filtrado],
      "Expanded" => Interaccion.estado_envios[:expandido],
      "Failed" => Interaccion.estado_envios[:fallido]
    }
    mapper.fetch(estado, nil)
  end
end
