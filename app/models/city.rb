class City < ApplicationRecord
  belongs_to :user
  validates :order, numericality: true, comparison: { greater_than: 0 }, uniqueness: { scope: %i[user_id order] }
  validates :longitude, :latitude, :city_name, :country, presence: true
  validates :city_id, uniqueness: { scope: %i[user_id city_id] }, presence: true

  scope :filter_by_user, ->(user) { where(cities: { user_id: user.id }) }
  scope :main_city, ->(user) { where(cities: { user_id: user.id, order: 1 }) }
end
