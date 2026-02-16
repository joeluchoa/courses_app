FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    description { "A test course" }
    address { "Test Address" }
    start_date { 1.day.ago }
    end_date { 1.month.from_now }
    teacher

    after(:build) do |course|
      # Add a schedule for every day of the week to ensure it's valid for attendance
      course.weekly_schedule ||= []
      days = %w[monday tuesday wednesday thursday friday saturday sunday]
      days.each do |day|
        course.weekly_schedule << {
          "day" => day,
          "start_time" => "09:00",
          "end_time" => "10:00",
          "enabled" => "1"
        }
      end
    end
  end
end
