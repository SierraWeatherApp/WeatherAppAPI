class City < ApplicationRecord
  validates_presence_of :weather_id, :name, :country, :latitude, :longitude
  validates_uniqueness_of :weather_id
  validates :latitude, uniqueness: { scope: %i[latitude longitude] }, presence: true
end
