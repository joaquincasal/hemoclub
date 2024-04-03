class CreateDifusiones < ActiveRecord::Migration[7.1]
  def change
    create_table :difusiones do |t|
      t.string :nombre
      t.references :lista_dinamica, null: false, foreign_key: true
      t.references :plantilla, null: false, foreign_key: true

      t.timestamps
    end
  end
end
