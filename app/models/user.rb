class User < ApplicationRecord
  validates_presence_of :device_id
  validates_uniqueness_of :device_id
  validate :duplicate_check

  private

  def duplicate_check
    return if cities_ids.uniq.length == cities_ids.length

    errors.add(:cities_ids, 'repeating_entry')
  end
end
