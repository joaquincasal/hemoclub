class RenameDifusionToCampania < ActiveRecord::Migration[7.1]
  def change
    rename_table :difusiones, :campanias
  end
end
