class AjustarTipoMotivoRechazo < ActiveRecord::Migration[7.1]
  def change
    change_column :donaciones, :motivo_rechazo, :integer, using: 'motivo_rechazo::integer'
    change_column :donantes, :motivo_rechazo_predonante_plaquetas, :integer, using: 'motivo_rechazo_predonante_plaquetas::integer'
  end
end
