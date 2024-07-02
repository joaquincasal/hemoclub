class CreateExclusionesTipicas < ActiveRecord::Migration[7.1]
  def change
    create_table :exclusiones_tipicas do |t|
      t.integer :duracion
      t.string :motivo

      t.timestamps
    end
  end
end
