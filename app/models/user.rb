class User < ApplicationRecord
  validates_presence_of :device_id
  validates_uniqueness_of :device_id
  validate :duplicate_check
  validate :temperature_units
  validate :gender_name
  validate :look_number

  private

  def duplicate_check
    return if cities_ids.uniq.length == cities_ids.length

    errors.add(:cities_ids, 'repeating_entry')
  end

  def temperature_units
    return if temp_units == 'celsius' || temp_units == 'fahrenheit'

    errors.add(:temp_units, 'incorrect_temp_format')
  end

  def gender_name
    return if gender == 'female' || gender == 'male'

    errors.add(:gender, 'incorrect_gender_format')
  end

  def look_number
    return if look >= 0

    errors.add(:gender, 'incorrect_look_format')
  end

end
