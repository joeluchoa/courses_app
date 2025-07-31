class ScannerController < ApplicationController
  def index
  end

  def confirm
    begin
      @student = Student.find(params[:student_id])
      @enrolled_courses = @student.courses.order(:name)

      if @enrolled_courses.empty?
        redirect_to scanner_path, alert: "This student is not enrolled in any courses."
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to scanner_path, alert: "Invalid QR Code: Student not found."
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
