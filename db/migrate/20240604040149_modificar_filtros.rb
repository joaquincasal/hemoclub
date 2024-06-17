class ModificarFiltros < ActiveRecord::Migration[7.1]
  def change
    remove_column :filtros, :condiciones
    remove_column :filtros, :nombre
    add_column :filtros, :parametros, :json
    add_column :filtros, :type, :string
  end
end
