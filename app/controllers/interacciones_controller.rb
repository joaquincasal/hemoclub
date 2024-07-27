class InteraccionesController < IntegracionesController
  def update
    evento = JSON.parse(request.raw_post)
    id_mensaje = evento["messageId"]
    if evento["eventType"] == "Microsoft.Communication.EmailDeliveryReportReceived"
      estado = evento["status"]
      Interaccion.find_by(id_mensaje: id_mensaje).actualizar_estado_envio(estado)
    elsif event["eventType"] == "Microsoft.Communication.EmailEngagementTrackingReportReceived" &&
          evento["data"]["engagementType"] == "view"
      Interaccion.find_by(id_mensaje: id_mensaje).marcar_leido
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
