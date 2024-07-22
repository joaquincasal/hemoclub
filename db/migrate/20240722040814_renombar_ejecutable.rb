class RenombarEjecutable < ActiveRecord::Migration[7.1]
  def change
    remove_column :ejecuciones, :ejecutable_type
    rename_column :ejecuciones, :ejecutable_id, :comunicacion_id
    remove_column :interacciones, :ejecutable_type
    rename_column :interacciones, :ejecutable_id, :comunicacion_id
  end
end
