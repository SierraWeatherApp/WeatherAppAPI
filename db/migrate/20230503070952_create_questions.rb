class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :question
      t.integer :min, default: 0
      t.integer :max, default: 1
      t.timestamps
    end
  end
end
