require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @admin = create(:user, :admin)
    @student = create(:student)
    sign_in @admin, scope: :user
  end

  test "should get index" do
    get students_url(locale: :en)
    assert_response :success
  end

  test "should filter students by status" do
    # Create an active student
    active_course = create(:course, end_date: 1.month.from_now)
    active_student = create(:student)
    active_student.courses << active_course

    # Create an inactive student
    inactive_course = create(:course, end_date: 1.month.ago)
    inactive_student = create(:student)
    inactive_student.courses << inactive_course

    # Filter by active
    get students_url(locale: :en, status: ["active"])
    assert_response :success
    assert_select "td", text: active_student.full_name
    assert_select "td", text: inactive_student.full_name, count: 0

    # Filter by inactive
    get students_url(locale: :en, status: ["inactive"])
    assert_response :success
    assert_select "td", text: inactive_student.full_name
    assert_select "td", text: active_student.full_name, count: 0
  end

  test "should search students by name" do
    student1 = create(:student, first_name: "John", last_name: "Doe")
    student2 = create(:student, first_name: "Jane", last_name: "Smith")

    # Search by first name
    get students_url(locale: :en, query: "John")
    assert_response :success
    assert_select "td", text: student1.full_name
    assert_select "td", text: student2.full_name, count: 0

    # Search by last name
    get students_url(locale: :en, query: "Smith")
    assert_response :success
    assert_select "td", text: student2.full_name
    assert_select "td", text: student1.full_name, count: 0

    # Case insensitive search
    get students_url(locale: :en, query: "john")
    assert_response :success
    assert_select "td", text: student1.full_name
  end



  test "should get new" do
    get new_student_url(locale: :en)
    assert_response :success
  end

  test "should create student" do
    email = "new_student@example.com"
    assert_difference("Student.count") do
      post students_url(locale: :en), params: { student: { email: email, first_name: "New", last_name: "Student" } }
    end

    student = Student.find_by(email: email)
    assert_redirected_to student_url(student, locale: :en)
  end

  test "should show student" do
    get student_url(@student, locale: :en)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student, locale: :en)
    assert_response :success
  end

  test "should update student" do
    patch student_url(@student, locale: :en), params: { student: { email: @student.email, first_name: "Updated", last_name: @student.last_name } }
    assert_redirected_to student_url(@student, locale: :en)
  end

  test "should not create student with invalid data" do
    assert_no_difference("Student.count") do
      post students_url(locale: :en), params: { student: { first_name: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should not update student with invalid data" do
    patch student_url(@student, locale: :en), params: { student: { first_name: "" } }
    assert_response :unprocessable_entity
  end

  test "should get badge" do
    course = create(:course)
    @student.courses << course
    get student_badge_url(@student, course_id: course.id, locale: :en)
    assert_response :success
  end

  test "should destroy student" do

    assert_difference("Student.count", -1) do
      delete student_url(@student, locale: :en)
    end

    assert_redirected_to students_url(locale: :en)
  end
end
