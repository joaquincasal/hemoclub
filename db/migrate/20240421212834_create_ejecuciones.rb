class CreateEjecuciones < ActiveRecord::Migration[7.1]
  def change
    create_table :ejecuciones do |t|
      t.references :ejecutable, polymorphic: true
      t.datetime :fecha, default: -> { 'CURRENT_TIMESTAMP' }
      t.boolean :ejecutada, default: false

      t.timestamps
    end

    create_table :donantes_ejecuciones, id: false do |t|
      t.belongs_to :ejecucion
      t.belongs_to :donante
    end
  end
end
