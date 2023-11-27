class AjustarCamposDonanteDonaciones < ActiveRecord::Migration[7.1]
  def change
    remove_column :donaciones, :predonante_plaquetas
    remove_column :donaciones, :motivo_rechazo_predonante_plaquetas
    remove_column :donaciones, :origen_candidato

    add_column :donaciones, :colecta, :boolean
    add_column :donaciones, :relacionado, :boolean

    add_column :donantes, :predonante_plaquetas, :boolean
    add_column :donantes, :motivo_rechazo_predonante_plaquetas, :string
  end
end
