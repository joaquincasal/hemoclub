class CambiarCondicionesDeFiltros < ActiveRecord::Migration[7.1]
  def change
    change_column :filtros, :condiciones, :json, using: "condiciones::json"
  end
end
