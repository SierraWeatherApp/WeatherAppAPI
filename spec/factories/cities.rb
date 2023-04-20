FactoryBot.define do
    factory :city do
      city_id { 2673730 }
      city_name { "Stockholm" }
      country { "Sweden" }
      latitude { 59.33459 }
      longitude { 18.06324 }
      order { 1 }
      association :user
    end
  end