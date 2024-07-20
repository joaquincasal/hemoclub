class SacarListasEstaticas < ActiveRecord::Migration[7.1]
  def change
    remove_column :listas, :type
    drop_table :donantes_listas
  end
end
