class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :course
  # Ensure a student can only be enrolled once per course
  validates :student_id, uniqueness: { scope: :course_id }
end
