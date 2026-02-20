require "test_helper"

class ScannerControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @admin = create(:user, :admin)
    @student = create(:student)
    @course = create(:course)
    @student.courses << @course
    sign_in @admin, scope: :user
  end

  test "should get index" do
    get scanner_url(locale: :en)
    assert_response :success
  end

  test "should get confirm" do
    get scanner_confirm_url(locale: :en, student_id: @student.id, course_id: @course.id)
    assert_response :success
  end

  test "should register_attendance" do
    assert_difference("Attendance.count") do
      post scanner_register_attendance_url(locale: :en, student_id: @student.id, course_id: @course.id)
    end
    assert_redirected_to scanner_path(locale: :en)
  end
end
