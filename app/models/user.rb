class User < ApplicationRecord
  validates_presence_of :device_id
  validates_uniqueness_of :device_id
  validate :duplicate_check
  validate :temperature_units
  private

  def duplicate_check
    return if cities_ids.uniq.length == cities_ids.length

    errors.add(:cities_ids, 'repeating_entry')
  end

  def temperature_units
    return if temp_units == "C" || temp_units == "F"

    errors.add(:temp_units, 'incorrect_temp_format')
  end
end
