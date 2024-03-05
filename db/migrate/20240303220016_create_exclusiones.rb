class CreateExclusiones < ActiveRecord::Migration[7.1]
  def change
    create_table :exclusiones do |t|
      t.date :fecha_inicio
      t.date :fecha_fin
      t.string :motivo
      t.references :donante, index: true

      t.timestamps
    end
  end
end
