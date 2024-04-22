class AgregarActivaACampania < ActiveRecord::Migration[7.1]
  def change
    add_column :campanias, :activa, :boolean, default: true
  end
end
