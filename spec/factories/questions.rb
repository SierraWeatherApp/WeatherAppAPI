FactoryBot.define do
  factory :question do
    question { Faker::Markdown.emphasis }
    min { 0 }
    max { 1 }
    label { 0 }
  end
end
