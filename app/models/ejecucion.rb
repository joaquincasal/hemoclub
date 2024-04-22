class Ejecucion < ApplicationRecord
  belongs_to :ejecutable, polymorphic: true
  has_and_belongs_to_many :donantes, dependant: :destroy

  def cancelar_envio
    GoodJob::Execution.where(job_class: "EnviarDifusionJob", performed_at: nil)
                      .where("serialized_params #>> '{arguments,0}' = ':id' ", id:)
                      .destroy_all
    destroy
  end
end
