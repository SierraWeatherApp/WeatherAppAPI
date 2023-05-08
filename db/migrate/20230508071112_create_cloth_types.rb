class CreateClothTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :cloth_types do |t|
      t.string :name
      t.string :section

      t.timestamps
    end
  end
end
