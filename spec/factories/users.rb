FactoryBot.define do
  factory :user do
    device_id { Faker::Config.random.to_s }
    cities_ids { [] }
    answers { { 'sandalUser' => 0, 'shortUser' => 0, 'capUser' => 0, 'userPlace' => 0, 'userTemp' => 0 } }
  end
end
