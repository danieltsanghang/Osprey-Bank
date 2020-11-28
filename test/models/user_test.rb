require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # Helper function for setting up a user object for testing purposes
  def setup
    @user_valid = User.new(:fname => "Alice", 
      :lname => "Williams", 
      :email => "alice.williams@gmail.com", 
      :username => "Alice101", 
      :password => "AlicePassword123", 
      :password_confirmation => "AlicePassword123",
      :isAdmin => false,
      :DOB => Date.new(1990-10-10),
      :phoneNumber => 123456789,
      :address => "London")

    @user_inValid = User.new(:fname => "Bob", 
      :lname => "Sacamano", 
      :email => "bob.sacamano@hotmail.com", 
      :username => "My friend Bob Sacamano", 
      :password => "Seinfeld101", 
      :password_confirmation => "Sacamano101",
      :isAdmin => false,
      :DOB => Date.new(1990-10-10),
      :phoneNumber => 123456789,
      :address => "London")
  end


  # Tests for user authenticationn:

  # Username tests

  test 'default user should be valid' do
    assert @user_valid.valid?
  end

  test 'user with non-matching password is invalid' do
    assert_not @user_inValid.valid?
  end

  test 'username should be no more than 20 characters' do
    @user_valid.username = 'x' * 21
    assert_not @user_valid.valid?
  end

  test 'username can be 20 characters long' do
    @user_valid.username = 'x' * 20
    assert @user_valid.valid?
  end

  test 'username should be atleast 6 characters' do
    @user_valid.username = 'x' * 5
    assert_not @user_valid.valid?
  end

  test 'username can be 6 characters long' do
    @user_valid.username = 'x' * 6
    assert @user_valid.valid?
  end

  test 'username should not be blank' do
    @user_valid.username = ' ' * 6
    assert_not @user_valid.valid?
  end

  test 'usernames should be stored as all lower case letters' do
    user_name = "USERNAME"
    @user_valid.username = user_name
    @user_valid.save
    user = User.find_by_username(@user_valid.username)
    assert user.username == user_name.downcase
  end

  test 'usernames should be unique' do
    duplicate_user = @user_valid.dup
    duplicate_user.username = duplicate_user.username.upcase
    @user_valid.save
    assert_not duplicate_user.valid?
  end

  # Password tests

  test 'password should not be blank' do
    @user_valid.password = @user_valid.password_confirmation =  ' ' * 8
    assert_not @user_valid.valid?
  end

  test 'password should be atleast 8 characters' do
    @user_valid.password = @user_valid.password_confirmation = 'x' * 7
    assert_not @user_valid.valid?
  end

  test 'password can be 8 characters long' do
    @user_valid.password = @user_valid.password_confirmation = 'x' * 8
    assert @user_valid.valid?
  end

  test 'password should be no more than 30 characters' do
    @user_valid.password = @user_valid.password_confirmation = 'x' * 31
    assert_not @user_valid.valid?
  end

  test 'password can be 30 characters long' do
    @user_valid.password = @user_valid.password_confirmation = 'x' * 30
    assert @user_valid.valid?
  end

  # Email tests

  test 'email should be valid' do
    @user_valid.email = 'blah'
    assert_not @user_valid.valid?
  end

  test 'emails should be unique' do
    duplicate_user = @user_valid.dup
    duplicate_user.username = 'Something Else'
    duplicate_user.email = duplicate_user.email.upcase
    @user_valid.save
    assert_not duplicate_user.valid?
  end

end
