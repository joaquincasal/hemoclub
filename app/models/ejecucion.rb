class Ejecucion < ApplicationRecord
  belongs_to :comunicacion
  has_many :interacciones, dependent: :destroy
  has_many :donantes, through: :interacciones

  def cancelar_envio
    GoodJob::Execution.where(job_class: "EnviarComunicacionJob", performed_at: nil)
                      .where("serialized_params #>> '{arguments,0}' = ':id' ", id: id)
                      .destroy_all
    destroy
  end
end
