require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @user = create(:user)
    sign_in @user, scope: :user
  end

  test "should get index" do
    get dashboard_url(locale: :en)
    assert_response :success
  end
end
