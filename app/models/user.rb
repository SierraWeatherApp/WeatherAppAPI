class User < ApplicationRecord
  has_many :cities

  validates_presence_of :device_id
  validates_uniqueness_of :device_id
end
