require "test_helper"

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    @course = create(:course)
    @student = create(:student)
    create(:enrollment, course: @course, student: @student)
    @attendance = create(:attendance, course: @course, student: @student)
    sign_in @user, scope: :user
  end

  test "should get index" do
    get course_attendances_url(@course, locale: :en)
    assert_response :success
  end

  test "should get new" do
    get new_course_attendance_url(@course, locale: :en)
    assert_response :success
  end

  test "should create attendance" do
    assert_difference("Attendance.count") do
      post course_attendances_url(@course, locale: :en), params: { 
        attendance: { 
          student_id: @student.id, 
          attended_on: Date.yesterday 
        } 
      }
    end

    assert_redirected_to course_attendances_url(@course, locale: :en)
  end

  test "should create attendance via attendance table toggle" do
    # Remove existing attendance first
    @attendance.destroy
    
    # Try creating for a day that is NOT a class day (to test manual_entry bypass)
    # The course factory usually creates a schedule for specific days.
    # Let's pick a day far in the past that is unlikely to be in the schedule if it were strictly enforced.
    
    assert_difference("Attendance.count") do
      post course_attendances_url(@course, locale: :en), params: { 
        attendance: { 
          student_id: @student.id, 
          attended_on: Date.new(2020, 1, 1) 
        } 
      }
    end
    assert_redirected_to course_attendances_url(@course, locale: :en)
  end

  test "should show attendance" do
    get course_attendance_url(@course, @attendance, locale: :en)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_attendance_url(@course, @attendance, locale: :en)
    assert_response :success
  end

  test "should update attendance" do
    new_date = Date.yesterday - 1.day
    patch course_attendance_url(@course, @attendance, locale: :en), params: { 
      attendance: { attended_on: new_date } 
    }
    assert_redirected_to course_attendances_url(@course, locale: :en)
    @attendance.reload
    assert_equal new_date.to_date, @attendance.attended_on.to_date
  end

  test "should destroy attendance" do
    assert_difference("Attendance.count", -1) do
      delete course_attendance_url(@course, @attendance, locale: :en)
    end

    assert_redirected_to course_attendances_url(@course, locale: :en)
  end
end
