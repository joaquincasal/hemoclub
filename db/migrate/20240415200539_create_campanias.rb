class CreateCampanias < ActiveRecord::Migration[7.1]
  def change
    create_table :campanias do |t|
      t.string :nombre
      t.references :lista, null: false, foreign_key: true
      t.references :plantilla, null: false, foreign_key: true

      t.timestamps
    end

    rename_column :difusiones, :lista_dinamica_id, :lista_id
  end
end
