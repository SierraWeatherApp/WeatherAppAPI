class Question < ApplicationRecord
  validates_presence_of :question
  validates_uniqueness_of :question
  validates_presence_of :label
  validates_uniqueness_of :label
  validate :min_max_relation, :zero_included

  enum :label, %i[sandalUser shortUser capUser userPlace userTemp]

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
