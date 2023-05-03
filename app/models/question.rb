class Question < ApplicationRecord
  validates_presence_of :question
  validates_uniqueness_of :question
  validate :min_max_relation, :zero_included

  private

  def min_max_relation
    return if min < max

    errors.add(:min, 'can not be bigger or equal to max')
  end

  def zero_included
    return if min <= 0 && max >= 0

    errors.add(:min, '0 must be between min and max values')
  end
end

