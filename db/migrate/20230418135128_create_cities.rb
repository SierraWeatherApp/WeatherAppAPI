class CreateCities < ActiveRecord::Migration[7.0]
  def change
    create_table :cities do |t|
      t.belongs_to :user

      t.float :latitude, default: 0.0
      t.float :longitude, default: 0.0
      t.integer :city_id
      t.string :city_name
      t.string :country
      t.integer :order, default: 0
      t.timestamps
    end
  end
end
