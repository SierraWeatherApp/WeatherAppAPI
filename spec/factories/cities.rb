FactoryBot.define do
  factory :city do
    name { 'Stockholm' }
    country { 'Sweden' }
    latitude { 59.33459 }
    longitude { 18.06324 }
    weather_id { Faker::Number.number(digits: 15) }
  end
end
