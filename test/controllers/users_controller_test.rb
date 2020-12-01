require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  # called before every single test
  setup do
    user = users(:user)
  end

  # called after every single test
  teardown do
    # if controller is using cache it may be a good idea to reset it afterwards
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
    put  :update, :id => users(user), :user => {:fname => "Alice"}
    assert_redirected_to user_path(user)
    # reload the useer to update changes
    user.reload
    assert_equal "Alice", user.fname
  end

  test "should update user last name" do
    put  :update, :id => users(user), :user => {:lname => "Williams"}
    assert_redirected_to user_path(user)
    # reload the useer to update changes
    user.reload
    assert_equal "Williams", user.lname
  end

  test "should update user email" do
    put  :update, :id => users(user), :user => {:email => "testuser@gmail.com"}
    assert_redirected_to user_path(user)
    # reload the useer to update changes
    user.reload
    assert_equal "testuser@gmail.com", user.email
  end

  test "should update user username" do
    put  :update, :id => users(user), :user => {:username => "awilliams"}
    assert_redirected_to user_path(user)
    # reload the useer to update changes
    user.reload
    assert_equal "awilliams", user.username
  end

  test "should update user phone number" do
    put  :update, :id => users(user), :user => {:phoneNumber => 07000111000}
    assert_redirected_to user_path(user)
    # reload the useer to update changes
    user.reload
    assert_equal 07000111000, user.phoneNumber
  end

  test "should update user address" do
    put  :update, :id => users(user), :user => {:address => "Old York"}
    assert_redirected_to user_path(user)
    # reload the useer to update changes
    user.reload
    assert_equal "Old York", user.address
  end

  test "should not update username if invalid" do
    put  :update, :id => users(user), :user => {:username => "alice"}
    assert_redirected_to edit_user_path(user)
    # reload the useer to update changes
    user.reload
    assert_not_equal "alice", user.username
  end

  test "should not update email if invalid" do
    put  :update, :id => users(user), :user => {:email => "alice"}
    assert_redirected_to edit_user_path(user)
    # reload the useer to update changes
    user.reload
    assert_not_equal "alice", user.email
  end

  test "should not update phone number if invalid" do
    put  :update, :id => users(user), :user => {:phoneNumber => 3}
    assert_redirected_to edit_user_path(user)
    # reload the useer to update changes
    user.reload
    assert_not_equal 3, user.phoneNumber
  end

  test "should not update address if invalid" do
    put  :update, :id => users(user), :user => {:address => nil}
    assert_redirected_to edit_user_path(user)
    # reload the useer to update changes
    user.reload
    assert_not_equal nil, user.address
  end

  test "should login with updated user" do
    put  :update, :id => users(user), :user => {:username => "awilliams"}
    login_as_user(user)
    assert_response :success
  end

end
