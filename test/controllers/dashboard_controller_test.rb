require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @user = create(:user)
    sign_in @user, scope: :user
  end

  test "should get index and show activity links" do
    create(:attendance) if Attendance.count == 0
    attendance = Attendance.first
    
    get dashboard_url(locale: :en)
    assert_response :success
    assert_select "div.activity-list" do
      assert_select "a[href=?]", student_path(attendance.student, locale: :en), text: attendance.student.full_name
      assert_select "a[href=?]", course_path(attendance.course, locale: :en), text: attendance.course.name
    end
  end
end
