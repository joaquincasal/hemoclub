class RenombrarHeaderYFooter < ActiveRecord::Migration[7.1]
  def change
    rename_column :plantillas, :header_id, :encabezado_id
    rename_column :plantillas, :footer_id, :firma_id
  end
end
