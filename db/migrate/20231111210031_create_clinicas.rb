class CreateClinicas < ActiveRecord::Migration[7.1]
  def change
    create_table :clinicas, id: false do |t|
      t.integer :codigo, primary_key: true
      t.string :nombre

      t.timestamps
    end
  end
end
