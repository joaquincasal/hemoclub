class CreateListaDinamicas < ActiveRecord::Migration[7.1]
  def change
    create_table :listas_dinamicas do |t|
      t.string :nombre

      t.timestamps
    end
    add_column :filtros, :lista_dinamica_id, :bigint
  end
end
