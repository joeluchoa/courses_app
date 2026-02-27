require "test_helper"

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    # Create a course with a specific schedule (only Saturdays)
    @course = create(:course, start_date: 1.month.ago, end_date: 1.month.from_now)
    @course.weekly_schedule = [
      { "day" => "Saturday", "start_time" => "09:00", "end_time" => "10:00", "enabled" => "1" }
    ]
    @course.save!
    
    @student = create(:student)
    create(:enrollment, course: @course, student: @student)

    
    # Ensure @valid_day is a Saturday. 
    # Today is 2026-02-21 (Saturday).
    @valid_day = Date.new(2026, 2, 21)
    
    @attendance = create(:attendance, course: @course, student: @student, attended_on: @valid_day)
    
    sign_in @user, scope: :user
  end

  test "should get global index" do
    get attendances_url(locale: :en)
    assert_response :success
    assert_select "h1", text: "Attendances"
  end

  test "should get course-specific index" do
    get course_attendances_url(@course, locale: :en)
    assert_response :success
    assert_select "h1", text: /Attendances: #{@course.name}/
  end

  test "should filter global index by course" do
    other_course = create(:course)
    get attendances_url(locale: :en, filter_course_id: @course.id)
    assert_response :success
    assert_select "td", text: @course.name
    # Note: If there are multiple attendances, this might be more complex, 
    # but for a basic check it's okay.
  end

  test "should filter by date" do
    get attendances_url(locale: :en, filter_date: @valid_day.to_s)
    assert_response :success
    assert_select "td", text: /#{I18n.l(@valid_day, format: :long)}/
  end

  test "should get new" do
    get new_course_attendance_url(@course, locale: :en)
    assert_response :success
  end

  test "should create manual attendance" do
    # Find another valid class day for this course
    # Assuming Saturday is valid, let's try next Saturday
    next_valid_day = @valid_day + 7.days
    
    assert_difference("Attendance.count") do
      post course_attendances_url(@course, locale: :en), params: { 
        attendance: { 
          student_id: @student.id, 
          attended_on: next_valid_day 
        } 
      }
    end

    assert_redirected_to course_attendances_url(@course, locale: :en)
    assert Attendance.last.manual?
  end

  test "should NOT create attendance for invalid class day" do
    # Pick a day that is likely NOT in the schedule (e.g., a Monday if Sat is scheduled)
    invalid_day = @valid_day + 2.days 
    
    assert_no_difference("Attendance.count") do
      post course_attendances_url(@course, locale: :en), params: { 
        attendance: { 
          student_id: @student.id, 
          attended_on: invalid_day 
        } 
      }
    end
    assert_response :unprocessable_entity
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
    # Move to another valid day
    new_valid_day = @valid_day + 14.days
    patch course_attendance_url(@course, @attendance, locale: :en), params: { 
      attendance: { attended_on: new_valid_day } 
    }
    assert_redirected_to course_attendances_url(@course, locale: :en)
    @attendance.reload
    assert_equal new_valid_day.to_date, @attendance.attended_on.to_date
  end

  test "should destroy attendance" do
    assert_difference("Attendance.count", -1) do
      delete course_attendance_url(@course, @attendance, locale: :en)
    end

    assert_redirected_to course_attendances_url(@course, locale: :en)
  end
end
