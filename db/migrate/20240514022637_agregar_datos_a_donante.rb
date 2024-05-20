class AgregarDatosADonante < ActiveRecord::Migration[7.1]
  def change
    add_column :donantes, :donaciones_count, :integer, default: 0
    add_column :donantes, :respondio_bienvenida, :boolean
    add_column :donantes, :ultima_donacion_id, :bigint
  end
end
