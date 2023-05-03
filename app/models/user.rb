class User < ApplicationRecord
  validates_presence_of :device_id
  validates_uniqueness_of :device_id
  validates :look, numericality: true, comparison: { greater_than_or_equal_to: 0 }
  validate :duplicate_check, :temperature_unit, :gender_name

  private

  def duplicate_check
    return if cities_ids.uniq.length == cities_ids.length

    errors.add(:cities_ids, 'repeating_entry')
  end

  def temperature_unit
    return if temp_unit == 'celsius' || temp_unit == 'fahrenheit'

    errors.add(:temp_unit, 'incorrect_temp_format')
  end

  def gender_name
    return if gender == 'female' || gender == 'male'

    errors.add(:gender, 'incorrect_gender_format')
  end
end
