class CreateInteracciones < ActiveRecord::Migration[7.1]
  def change
    #drop_table :donantes_ejecuciones
    create_table :interacciones do |t|
      t.references :donante, null: false, foreign_key: true
      t.references :ejecucion, null: false, foreign_key: true
      t.integer :estado_envio
      t.integer :estado_interaccion

      t.timestamps
    end
  end
end
