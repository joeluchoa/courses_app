require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @user = create(:user)
    sign_in @user, scope: :user
  end

  test "should get index and show activity links in all locales" do
    create(:attendance) if Attendance.count == 0
    attendance = Attendance.first
    
    [:en, :it, :pt].each do |locale|
      get dashboard_url(locale: locale)
      assert_response :success, "Failed for locale #{locale}"
      assert_select "div.activity-list", 1, "Activity list missing for #{locale}" do
        assert_select "a[href=?]", student_path(attendance.student, locale: locale), text: attendance.student.full_name
        assert_select "a[href=?]", course_path(attendance.course, locale: locale), text: attendance.course.name
      end
    end
  end
end
