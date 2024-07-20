class CrearComunicaciones < ActiveRecord::Migration[7.1]
  def change
    drop_table :campanias
    rename_table :automatizaciones, :comunicaciones
    add_column :comunicaciones, :type, :string
  end
end
