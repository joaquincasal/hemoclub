class CreateListasEstaticas < ActiveRecord::Migration[7.1]
  def change
    rename_table :listas_dinamicas, :listas
    add_column :listas, :type, :string
    rename_column :filtros, :lista_dinamica_id, :lista_id

    create_table :donantes_listas, id: false do |t|
      t.belongs_to :donante
      t.belongs_to :lista_estatica
    end
    add_index :donantes_listas, [:donante_id, :lista_estatica_id]
  end
end
