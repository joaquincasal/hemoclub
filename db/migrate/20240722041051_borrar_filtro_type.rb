class BorrarFiltroType < ActiveRecord::Migration[7.1]
  def change
    remove_column :filtros, :type
  end
end
