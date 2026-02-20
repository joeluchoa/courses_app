require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @user = create(:user)
    sign_in @user, scope: :user
  end

  test "should get show" do
    get profile_url(locale: :en)
    assert_response :success
  end
end
