require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @admin = create(:user, :admin)
    @course = create(:course)
    sign_in @admin, scope: :user
  end

  test "should get index" do
    get courses_url(locale: :en)
    assert_response :success
  end

  test "should get new" do
    get new_course_url(locale: :en)
    assert_response :success
  end

  test "should create course" do
    name = "New Course"
    assert_difference("Course.count") do
      post courses_url(locale: :en), params: { course: { description: @course.description, name: name, address: "Some Address", teacher_id: @course.teacher_id } }
    end

    course = Course.find_by(name: name)
    assert_redirected_to course_url(course, locale: :en)
  end

  test "should show course" do
    get course_url(@course, locale: :en)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_url(@course, locale: :en)
    assert_response :success
  end

  test "should update course" do
    patch course_url(@course, locale: :en), params: { course: { description: @course.description, name: "Updated Name" } }
    assert_redirected_to course_url(@course, locale: :en)
  end

  test "should destroy course" do
    assert_difference("Course.count", -1) do
      delete course_url(@course, locale: :en)
    end

    assert_redirected_to courses_url(locale: :en)
  end
end
