# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_508_071_112) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'cities', force: :cascade do |t|
    t.bigint 'weather_id'
    t.string 'name'
    t.string 'country'
    t.float 'latitude'
    t.float 'longitude'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'cloth_types', force: :cascade do |t|
    t.string 'name'
    t.string 'section'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'questions', force: :cascade do |t|
    t.string 'question'
    t.integer 'label'
    t.integer 'min', default: 0
    t.integer 'max', default: 1
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'device_id'
    t.string 'temp_unit', default: 'celsius'
    t.string 'gender', default: 'female'
    t.integer 'look', default: 0
    t.integer 'cities_ids', default: [], array: true
    t.json 'answers', default: {}
    t.json 'preferences', default: {}
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
