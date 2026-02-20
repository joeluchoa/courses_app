require "test_helper"

class EnrollmentsControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @admin = create(:user, :admin)
    @course = create(:course)
    @student = create(:student)
    @enrollment = create(:enrollment, course: @course, student: @student)
    sign_in @admin, scope: :user
  end

  test "should create enrollment" do
    other_student = create(:student)
    assert_difference("Enrollment.count") do
      post course_enrollments_url(@course, locale: :en), params: { enrollment: { student_id: other_student.id } }
    end

    assert_redirected_to course_url(@course, locale: :en)
  end

  test "should destroy enrollment" do
    assert_difference("Enrollment.count", -1) do
      delete course_enrollment_url(@course, @enrollment, locale: :en)
    end

    assert_redirected_to course_url(@course, locale: :en)
  end
end
