class InteraccionesController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_usuario!

  # rubocop:disable Metrics/AbcSize,Lint/UnreachableCode
  def update
    return head :unauthorized if ENV["WEBHOOK_KEY"] != params[:key]

    return head :ok

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
  # rubocop:enable Metrics/AbcSize,Lint/UnreachableCode
end
