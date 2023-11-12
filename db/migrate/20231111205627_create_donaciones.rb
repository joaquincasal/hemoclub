class CreateDonaciones < ActiveRecord::Migration[7.1]
  def change
    create_table :donaciones do |t|
      t.string :codigo_ingreso
      t.date :fecha
      t.integer :serologia
      t.boolean :predonante_plaquetas
      t.string :motivo_rechazo
      t.string :motivo_rechazo_predonante_plaquetas
      t.string :origen_candidato
      t.references :donante, index: true
      t.references :clinica, index: true

      t.timestamps
    end
  end
end
