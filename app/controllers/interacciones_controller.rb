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
end
