require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  setup do
    @admin = create(:user, :admin)
    @user = create(:user)
    sign_in @admin, scope: :user
  end

  test "should get index" do
    get admin_users_url(locale: :en)
    assert_response :success
  end

  test "should get new" do
    get new_admin_user_url(locale: :en)
    assert_response :success
  end

  test "should create user with name" do
    email = "new_user@example.com"
    assert_difference("User.count") do
      post admin_users_url(locale: :en), params: {
        user: {
          name: "New User",
          email: email,
          password: "password123",
          password_confirmation: "password123",
          role: "operator"
        }
      }
    end

    assert_redirected_to admin_users_path(locale: :en)
    created_user = User.find_by(email: email)
    assert_not_nil created_user, "User was not found by email"
    assert_equal "New User", created_user.name
  end

  test "should create user in blocked state" do
    email = "blocked_user@example.com"
    assert_difference("User.count") do
      post admin_users_url(locale: :en), params: {
        user: {
          name: "Blocked User",
          email: email,
          password: "password123",
          password_confirmation: "password123",
          role: "operator",
          block: "1"
        }
      }
    end

    assert_redirected_to admin_users_path(locale: :en)
    created_user = User.find_by(email: email)
    assert_not_nil created_user, "User was not found by email"
    assert created_user.blocked_at.present?, "User should be blocked"
  end

  test "should return unprocessable_entity when creation fails" do
    post admin_users_url(locale: :en), params: {
      user: {
        name: "", # Invalid: name is required
        email: "invalid@example.com",
        password: "password123",
        role: "operator"
      }
    }
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_admin_user_url(@user, locale: :en)
    assert_response :success
  end

  test "should update user name" do
    patch admin_user_url(@user, locale: :en), params: {
      user: {
        name: "Updated Name"
      }
    }
    assert_redirected_to admin_users_path(locale: :en)
    @user.reload
    assert_equal "Updated Name", @user.name
  end

  test "should block user during update" do
    patch admin_user_url(@user, locale: :en), params: {
      user: {
        block: "1"
      }
    }
    assert_redirected_to admin_users_path(locale: :en)
    @user.reload
    assert @user.blocked_at.present?
  end

  test "should unblock user during update" do
    @user.update!(blocked_at: Time.current)
    patch admin_user_url(@user, locale: :en), params: {
      user: {
        unblock: "1"
      }
    }
    assert_redirected_to admin_users_path(locale: :en)
    @user.reload
    assert_nil @user.blocked_at
  end

  test "should return unprocessable_entity when update fails" do
    patch admin_user_url(@user, locale: :en), params: {
      user: {
        name: "" # Invalid
      }
    }
    assert_response :unprocessable_entity
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete admin_user_url(@user, locale: :en)
    end

    assert_redirected_to admin_users_url(locale: :en)
  end
end
