class AgregarDonacionAInteraccion < ActiveRecord::Migration[7.1]
  def change
    add_column :interacciones, :donacion_id, :bigint
  end
end
