class RenombrarDonacionesCount < ActiveRecord::Migration[7.1]
  def change
    rename_column :donantes, :donaciones_count, :cantidad_donaciones
  end
end
