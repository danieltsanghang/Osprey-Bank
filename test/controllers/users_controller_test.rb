require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  # called before every single test
  setup do
    @user = users(:user)
    login_as_user(@user, "password1")
  end

  # called after every single test
  teardown do
    # if controller is using cache it may be a good idea to reset it afterwards
    logout
    Rails.cache.clear
  end

  test "should show user" do
    user = users(:user)
    # Get user from fixtures and login
    login_as_user(user, "password1")
    assert_response :redirect # User redirected after authenticated

    # Show user profile
    get user_url(user)
    assert_response :success
  end

  test "should update user first name" do
    patch  user_url(@user), params: { :user => {:fname => "Alice"} }
    assert_redirected_to user_path(@user)
    # reload the user to update changes
    @user.reload
    assert_equal "Alice", @user.fname
  end

  test "should update user last name" do
    patch  user_url(@user), params: { :user => {:lname => "Williams"} }
    assert_redirected_to user_path(@user)
    # reload the user to update changes
    @user.reload
    assert_equal "Williams", @user.lname
  end

  test "should update user email" do
    patch  user_url(@user), params: { :user => {:email => "testuser@gmail.com"} }
    assert_redirected_to user_path(@user)
    # reload the user to update changes
    @user.reload
    assert_equal "testuser@gmail.com", @user.email
  end

  test "should update user username" do
    patch  user_url(@user), params: { :user => {:username => "awilliams"} }
    assert_redirected_to user_path(@user)
    # reload the user to update changes
    @user.reload
    assert_equal "awilliams", @user.username
  end

  test "should update user phone number" do
    patch  user_url(@user), params: { :user => {:phoneNumber => 07000111000} }
    assert_redirected_to user_path(@user)
    # reload the user to update changes
    @user.reload
    assert_equal 07000111000, @user.phoneNumber
  end

  test "should update user address" do
    patch  user_url(@user), params: { :user => {:address => "Old York"} }
    assert_redirected_to user_path(@user)
    # reload the user to update changes
    @user.reload
    assert_equal "Old York", @user.address
  end

  test "should not update username if invalid" do
    patch  user_url(@user), params: { :user => {:username => "alice"} }
    assert_template 'users/edit'
    # reload the user to update changes
    @user.reload
    assert_not_equal "alice", @user.username
  end

  test "should not update email if invalid" do
    patch  user_url(@user), params: { :user => {:email => "alice"} }
    assert_template 'users/edit'
    # reload the user to update changes
    @user.reload
    assert_not_equal "alice", @user.email
  end

  test "should not update phone number if invalid" do
    patch  user_url(@user), params: { :user => {:phoneNumber => 3} }
    assert_template 'users/edit'
    # reload the user to update changes
    @user.reload
    assert_not_equal 3, @user.phoneNumber
  end

  test "should not update address if invalid" do
    patch  user_url(@user), params: { :user => {:address => nil} }
    assert_template 'users/edit'
    # reload the user to update changes
    @user.reload
    assert_not_equal nil, @user.address
  end

  test "should login with updated user" do
    patch  user_url(@user), params: { :user => {:username => "awilliams"} }
    login_as_user(@user, "password1")
    assert_response :success
  end

end
