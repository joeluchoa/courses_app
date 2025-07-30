class DashboardController < ApplicationController
  def index
    # Key Statistics
    @student_count = Student.count
    @course_count = Course.count

    # Recent Activity Feed
    # Eager load student and course to avoid N+1 queries in the view
    @recent_attendances = Attendance.includes(:student, :course).order(created_at: :desc).limit(5)
  end
end
