FactoryBot.define do
  factory :user do
    device_id { Faker::Config.random.to_s }
  end
end
