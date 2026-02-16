FactoryBot.define do
  factory :student do
    sequence(:first_name) { |n| "Student" }
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "student#{n}@example.com" }
  end
end
