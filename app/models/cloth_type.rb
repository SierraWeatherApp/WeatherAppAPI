class ClothType < ApplicationRecord
  validates_presence_of :name, :section
  validates_uniqueness_of :name
end
