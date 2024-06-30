class RenombrarCampanias < ActiveRecord::Migration[7.1]
  def change
    rename_table "campanias", "automatizaciones"
  end
end
