class CreatePlantillas < ActiveRecord::Migration[7.1]
  def change
    create_table :plantillas do |t|
      t.text :nombre
      t.text :contenido

      t.timestamps
    end
  end
end
