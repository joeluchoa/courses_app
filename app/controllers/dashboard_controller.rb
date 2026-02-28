class DashboardController < ApplicationController
  def index
    # Key statistics
    @student_count        = Student.count
    @active_student_count = Student.active.count
    @course_count         = Course.count
    @active_course_count  = Course.active.count
    @teacher_count        = Teacher.count
    @today_attendance     = Attendance.where("attended_on >= ?", Time.zone.now.beginning_of_day).count

    # Upcoming courses: start in the future, sorted soonest first
    @upcoming_courses = Course.where("start_date > ?", Time.zone.now)
                              .order(:start_date)
                              .includes(:teacher)
                              .limit(5)

    # Ongoing courses: started but not yet ended
    @ongoing_courses = Course.where("start_date <= ? AND end_date >= ?", Time.zone.now, Time.zone.now)
                             .order(:end_date)
                             .includes(:teacher)
                             .limit(5)

    # Recent Activity Feed — eager load to avoid N+1
    @recent_attendances = Attendance.includes(:student, :course)
                                    .order(attended_on: :desc)
                                    .limit(8)
  end
end
