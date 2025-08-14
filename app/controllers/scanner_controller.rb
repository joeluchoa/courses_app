class ScannerController < ApplicationController
  def index
  end

  def confirm
    begin
      @student = Student.find(params[:student_id])
      @course = Course.find(params[:course_id])

      @enrolled_courses = @student.courses.order(:name)

      unless @enrolled_courses.include?(@course)
        redirect_to scanner_path, alert: "The student (id: #{params[:student_id]}) is not enrolled in the course (id: #{params[:course_id]})."
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to scanner_path, alert: "Invalid QR Code: Student (id: #{params[:student_id]}) or Course (id: #{params[:course_id]}) not found."
    end
  end

  def register_attendance
    student = Student.find(params[:student_id])
    course = Course.find(params[:course_id])

    # Create the attendance record
    attendance = Attendance.new(student: student, course: course, attended_on: Date.today)

    if attendance.save
      redirect_to scanner_path, notice: "#{student.full_name} has been marked present for #{course.name}."
    else
      # This handles cases like trying to mark attendance twice for the same day
      redirect_to scanner_path, alert: "Failed to mark attendance: #{attendance.errors.full_messages.to_sentence}"
    end
  end
end
