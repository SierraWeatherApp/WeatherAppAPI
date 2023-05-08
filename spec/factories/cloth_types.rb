FactoryBot.define do
  factory :cloth_type do
    name { Faker::Name.first_name }
    section { 't_shirt' }
  end
end

