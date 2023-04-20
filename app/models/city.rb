class City < ApplicationRecord
    belongs_to :user
    validates :order, numericality: true, comparison: {greater_than: 0}
    validates :longitude, :latitude, :city_id, :city_name, :country, presence: true

    scope :filter_by_user, ->(user) {where(cities: {user_id: user.id})}
end