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

  test 'admin should be able to create a valid user' do
    post admin_users_url, params:
    { user:
      {
        id: 1000,
        fname: "Raymond",
        lname: "Reddington",
        email: "red@gmail.com",
        username: "blacklist123",
        password: "randompass123",
        password_confirmation: "randompass123",
        isAdmin: false,
        DOB: "1990-10-10",
        address: "New York",
        phoneNumber: 123456789
      }
    }

    assert_redirected_to admin_user_url(1000)
  end

  test 'admin should be able to create an admin' do
    post admin_users_url, params:
    { user:
      {
        id: 1005,
        fname: "Raymond",
        lname: "Reddington",
        email: "red@gmail.com",
        username: "blacklist123",
        password: "randompass123",
        password_confirmation: "randompass123",
        isAdmin: true,
        DOB: "1990-10-10",
        address: "New York",
        phoneNumber: 123456789
      }
    }

    assert_redirected_to admin_user_url(1005)
  end

  test 'admin should not be able to create an invalid user' do
    post admin_users_url, params:
    { user:
      {
        id: 1001,
        fname: "Raymond",
        lname: "Reddington",
        email: "red@gmail.com",
        username: "blacklist123",
        password: "randompass123",
        password_confirmation: "randompass123",
        isAdmin: false,
        DOB: "1990-10-10",
        address: "New York",
      }
    }

    # Render the new action again because it failed
    assert_template 'admin/users/new'
  end

  test 'admin should not be able to create a user with a non matching password and password confirmation' do
    post admin_users_url, params:
    { user:
      {
        id: 1002,
        fname: "Raymond",
        lname: "Reddington",
        email: "red@gmail.com",
        username: "blacklist123",
        password: "randompass123",
        password_confirmation: "randompass1234",
        isAdmin: false,
        DOB: "1990-10-10",
        address: "New York",
        phoneNumber: 123456789
      }
    }

    # Render the new action again because it failed due to different password and password confirmation
    assert_template 'admin/users/new'
  end

  test 'admin should not be able to create a user with an already existing username' do
    post admin_users_url, params:
    { user:
      {
        id: 1002,
        fname: "Raymond",
        lname: "Reddington",
        email: "red@gmail.com",
        username: "someuser",
        password: "randompass123",
        password_confirmation: "randompass123",
        isAdmin: false,
        DOB: "1990-10-10",
        address: "New York",
        phoneNumber: 123456789
      }
    }

    # Render the new action again because it failed due to different password and password confirmation
    assert_template 'admin/users/new'
  end

  test 'admin should not be able to create a user with an already existing email' do
    post admin_users_url, params:
    { user:
      {
        id: 1002,
        fname: "Raymond",
        lname: "Reddington",
        email: "testemail@yahoo.com",
        username: "blacklist",
        password: "randompass123",
        password_confirmation: "randompass123",
        isAdmin: false,
        DOB: "1990-10-10",
        address: "New York",
        phoneNumber: 123456789
      }
    }

    # Render the new action again because it failed due to different password and password confirmation
    assert_template 'admin/users/new'
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

  test "should show user" do
    # Show user profile
    get admin_user_url(@user)
    assert_response :success
  end

  test "should redirect 404 if user does not exist" do
    # finding a user that doesnt exist
    get admin_user_url(999)
    assert_response 404
  end

  test "admin should see all users" do
    get admin_users_url
    assert_response :success
  end
  test "normal user should not see all users" do
    login_as_user(@user, "password1")
    get admin_users_url
    assert_redirected_to login_url
  end

end
