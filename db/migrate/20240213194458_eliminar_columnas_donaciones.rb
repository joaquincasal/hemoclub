class EliminarColumnasDonaciones < ActiveRecord::Migration[7.1]
  def change
    remove_column :donaciones, :relacionado
    remove_column :donaciones, :colecta
    remove_column :donaciones, :codigo_ingreso
  end
end
