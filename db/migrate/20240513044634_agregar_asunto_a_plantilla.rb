class AgregarAsuntoAPlantilla < ActiveRecord::Migration[7.1]
  def change
    add_column :plantillas, :asunto, :string
  end
end
