require "test_helper"

class TeachersControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @admin = create(:user, :admin)
    @teacher = create(:teacher)
    sign_in @admin, scope: :user
  end

  test "should get index" do
    get teachers_url(locale: :en)
    assert_response :success
  end

  test "should get new" do
    get new_teacher_url(locale: :en)
    assert_response :success
  end

  test "should create teacher" do
    email = "new@example.com"
    assert_difference("Teacher.count") do
      post teachers_url(locale: :en), params: { teacher: { email: email, name: "New Teacher", phone_number: "123" } }
    end

    teacher = Teacher.find_by(email: email)
    assert_redirected_to teacher_url(teacher, locale: :en)
  end

  test "should show teacher" do
    get teacher_url(@teacher, locale: :en)
    assert_response :success
  end

  test "should get edit" do
    get edit_teacher_url(@teacher, locale: :en)
    assert_response :success
  end

  test "should update teacher" do
    patch teacher_url(@teacher, locale: :en), params: { teacher: { email: @teacher.email, name: "Updated Name", phone_number: @teacher.phone_number } }
    assert_redirected_to teacher_url(@teacher, locale: :en)
  end

  test "should destroy teacher" do
    assert_difference("Teacher.count", -1) do
      delete teacher_url(@teacher, locale: :en)
    end

    assert_redirected_to teachers_url(locale: :en)
  end
end
