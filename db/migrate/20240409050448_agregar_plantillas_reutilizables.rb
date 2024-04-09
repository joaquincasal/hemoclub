class AgregarPlantillasReutilizables < ActiveRecord::Migration[7.1]
  def change
    add_column :plantillas, :reutilizable, :boolean
    add_column :plantillas, :header_id, :bigint
    add_column :plantillas, :footer_id, :bigint
  end
end
