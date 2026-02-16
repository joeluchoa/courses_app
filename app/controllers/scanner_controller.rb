class ScannerController < ApplicationController
  def index
  end

  def confirm
    begin
      @student = Student.find(params[:student_id])
      @course = Course.find(params[:course_id])

      @enrolled_courses = @student.courses.order(:name)

      unless @enrolled_courses.include?(@course)
        redirect_to scanner_path, alert: t('scanner.flash.not_enrolled', student_id: params[:student_id], course_id: params[:course_id])
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to scanner_path, alert: t('scanner.flash.invalid_qr', student_id: params[:student_id], course_id: params[:course_id])
    end
  end

  def register_attendance
    student = Student.find(params[:student_id])
    course = Course.find(params[:course_id])

    # Create the attendance record
    attendance = Attendance.new(student: student, course: course, attended_on: Date.today)

    if attendance.save
      redirect_to scanner_path, notice: t('scanner.flash.marked_present', student: student.full_name, course: course.name)
    else
      # This handles cases like trying to mark attendance twice for the same day
      redirect_to scanner_path, alert: t('scanner.flash.failed_present', error: attendance.errors.full_messages.to_sentence)
    end
  end
end
