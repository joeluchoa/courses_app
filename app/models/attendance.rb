class Attendance < ApplicationRecord
  belongs_to :student
  belongs_to :course
  # A student can only have one attendance record per course per day
  validates :student_id, uniqueness: { scope: [:course_id, :attended_on] }
end
