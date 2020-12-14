require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # Integration test for between User and login functionality, help taken from LGT

  test 'login with valid credentials' do
    # Open the login page, should be a success
    get login_url
    assert_response :success

    
    user = users(:user_2)# Get the user needed to login

    assert_not is_logged_in? # User is not logged in yet
    assert_template 'sessions/new'

    login_as_user(user, "password2") # login
    assert_redirected_to user_url(user) # authenticated and redirected to the user's show page
    follow_redirect!
    assert_template 'users/show' # the template displayed is the user's show page
    assert is_logged_in? # user is logged in
  end

  test 'login with invalid credentials' do
    # Open the login page, should be a success
    get login_url
    assert_response :success

    
    user = users(:user_2)# Get the user needed to login

    assert_not is_logged_in? # User is not logged in yet
    assert_template 'sessions/new'

    login_as_user(user, "password1") # login with invalid credentials 
    assert_response :success
    assert_template 'sessions/new' # the template displayed is the login page again
    assert_not is_logged_in? # user is NOT logged in
  end

  test 'login as admin should redirect to admin namespace' do
    user = users(:admin)# Get the admin needed to login
    login_as_user(user, "password1") # login with valid credentials 
    
    assert_redirected_to admin_users_url # Should be redirected to admin/users
  end


end
