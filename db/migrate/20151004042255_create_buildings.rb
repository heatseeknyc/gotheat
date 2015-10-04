class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :building
      t.text :lat
      t.text :long
      t.integer :zip
      t.string :city
      t.boolean :score

      t.timestamps null: false
    end
  end
end
