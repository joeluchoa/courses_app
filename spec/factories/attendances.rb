FactoryBot.define do
  factory :attendance do
    student
    course
    attended_on { Date.today }
  end
end
