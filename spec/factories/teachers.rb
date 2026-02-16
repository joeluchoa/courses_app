FactoryBot.define do
  factory :teacher do
    sequence(:name) { |n| "Teacher #{n}" }
  end
end
