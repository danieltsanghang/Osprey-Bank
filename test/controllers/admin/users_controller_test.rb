require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)

    login_as_user(users(:admin), "password1")
  end

  def teardown
    logout
  end
  
  test 'admin should be able to edit a users password' do
    # Change user password
    patch edit_password_admin_user_url(@user.id), params: {  user: {password: "passwordnew", password_confirmation: "passwordnew"} }
    @user.reload
    logout

    # Login with new credentials and assert user is redirected to their show page
    login_as_user(users(:user), "passwordnew")
    assert_redirected_to user_path(@user)
  end

end
