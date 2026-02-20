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

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student, locale: :en)
    end

    assert_redirected_to students_url(locale: :en)
  end
end
