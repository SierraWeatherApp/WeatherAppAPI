class City < ApplicationRecord
    validates :order, numericality: true, comparison: {greater_than: 0}
    validates :longitude, :latitude, :city_id, :city_name, :country, presence: true
    #belongs_to :user
end