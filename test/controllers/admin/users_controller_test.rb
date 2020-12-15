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
        id: 3,
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

    assert_redirected_to admin_user_url(3)
  end

  test 'admin should be able to create an admin' do
    post admin_users_url, params:
    { user:
      {
        id: 3,
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

    assert_redirected_to admin_user_url(3)
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

  test 'admin should be able to edit a users fname to a valid fname' do
    patch admin_user_url(@user.id), params: {  user: { fname: "Alan" } }
    @user.reload

    assert @user.fname == "Alan"
  end

  test 'admin should not be able to edit a users fname to an invalid fname' do
    patch admin_user_url(@user.id), params: {  user: { fname: "B" } }
    @user.reload

    assert_not @user.fname == "B"
  end

  test 'admin should be able to edit a users email to a valid email' do
    patch admin_user_url(@user.id), params: {  user: { email: "alanturing@gmail.com" } }
    @user.reload

    assert @user.email == "alanturing@gmail.com"
  end

  test 'admin should not be able to edit a users email to an invalid email' do
    patch admin_user_url(@user.id), params: {  user: { email: "notarealemail.com" } }
    @user.reload

    assert_not @user.email == "notarealemail.com"
  end

  test 'admin should be able to edit a users username to a valid username' do
    patch admin_user_url(@user.id), params: {  user: { username: "alanturing" } }
    @user.reload

    assert @user.username == "alanturing"
  end

  test 'admin should not be able to edit a users username to an invalid username' do
    patch admin_user_url(@user.id), params: {  user: { username: "alan" } }
    @user.reload

    assert_not @user.username == "alan"
  end

  test 'admin should be able to make a user an admin' do
    patch admin_user_url(@user.id), params: {  user: { isAdmin: true } }
    @user.reload

    assert @user.isAdmin == true
  end

  test 'admin should be able to delete user' do
    assert_difference('User.count', -1) do
      delete admin_user_url(@user.id), params: {id: @user.id}
    end
    assert_redirected_to admin_users_url
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

  test 'search through all users correctly' do
    # Filter through users for a specific key (phoneNumber in this case), result should only be a list of length 1 based on the test fixtures
    get admin_users_path, params: { :search_user => 987654321 }
    assert assigns(:users).size == 1 
  end

  test 'search through all users with a value that does not exists correctly' do
    # Filter through users for a specific value that does not exist, result size should be 0
    get admin_users_path, params: { :search_user => "thisdoesnotexist" }
    assert assigns(:users).size == 0
  end

  test 'search through all users with empty string should return all users' do
    # Filter through users with empty string, all search_user should be returned (number of user fixtures = 6)
    get admin_users_path, params: { :search_user => "" }
    assert assigns(:users).size == 3
  end

  test 'sort through users should sort correctly' do
    # Sort by DOB in a descending order, this means the first result should have the greatest DOB which is the user with id = 0 based on the test fixtures
    get admin_users_path, params: { :sort => "DOB", :direction => "desc" }
    assert assigns(:users)[0].id == 0
  end

end
