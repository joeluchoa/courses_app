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

  test "should filter courses by name and status" do
    active_course = create(:course, name: "Active Ruby", end_date: 1.month.from_now)
    inactive_course = create(:course, name: "Old Java", end_date: 1.month.ago)

    # Filter by name
    get courses_url(locale: :en, query: "Ruby")
    assert_response :success
    assert_match "Active Ruby", response.body
    assert_no_match "Old Java", response.body

    # Filter by active status
    get courses_url(locale: :en, status: ["active"])
    assert_response :success
    assert_match "Active Ruby", response.body
    assert_no_match "Old Java", response.body

    # Filter by inactive status
    get courses_url(locale: :en, status: ["inactive"])
    assert_response :success
    assert_match "Old Java", response.body
    assert_no_match "Active Ruby", response.body
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
