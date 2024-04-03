class CreateFiltros < ActiveRecord::Migration[7.1]
  def change
    enable_extension "hstore"
    create_table :filtros do |t|
      t.string :nombre
      t.hstore :condiciones

      t.timestamps
    end
  end
end
