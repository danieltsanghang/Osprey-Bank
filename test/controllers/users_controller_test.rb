require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should show user" do
    # Get user from fixtures and login
    user = users(:user)
    login_as_user(user, "password1")
    assert_response :redirect # User redirected after authenticated

    # Show user profile
    get user_url(user)
    assert_response :success
  end
end
