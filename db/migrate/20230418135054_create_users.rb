class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :device_id
      t.string :temp_unit, default: 'celsius'
      t.string :gender, default: 'female'
      t.integer :look, default: 0
      t.integer :cities_ids, array: true, default: []
      t.json :answers, default: {}
      t.timestamps
    end
  end
end
