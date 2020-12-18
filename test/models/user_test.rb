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

  # Date of birth tests

  test 'date of birth should be valid' do
    @user_valid[:DOB] = "111/222/333"
    assert_not @user_valid.valid?
  end

  test 'date of birth should be parsed from a string' do
    @user_valid[:DOB] = "10/10/2001"
    assert @user_valid.valid?
  end

  test 'user can be 18 years old exactly' do
    @user_valid[:DOB] = 18.years.ago.to_datetime
    assert @user_valid.valid?
  end

  test 'user cannot be younger than 18 years old' do
    @user_valid[:DOB] = 18.years.ago.to_datetime + 1.day
    assert_not @user_valid.valid?
  end

  # Address tests

  test 'address cannot be empty' do
    @user_valid.address = ""
    assert_not @user_valid.valid?
  end

  test 'address cannot be less than 5 characters' do
    @user_valid.address = "nono"
    assert_not @user_valid.valid?
  end

  test 'address cannot be more than 60 characters' do
    @user_valid.address = "a" * 151
    assert_not @user_valid.valid?
  end


  # Admin tests

  test 'user can be an admin' do
    @user_valid.isAdmin = true
    assert @user_valid.valid?
  end

  test 'user is by default not an admin' do
    user = User.new(:fname => "Alice", 
      :lname => "Williams", 
      :email => "alice.williams@gmail.com", 
      :username => "Alice101", 
      :password => "AlicePassword123", 
      :password_confirmation => "AlicePassword123",
      :DOB => Date.new(1990-10-10),
      :phoneNumber => 123456789,
      :address => "London")

      assert user.valid?
      assert_not user.isAdmin
  end

  # Phone number tests

  test 'phoneNumber cannot be less than 9 digits' do
    @user_valid.phoneNumber = "12345678"
    assert_not @user_valid.valid?
  end

  test 'phoneNumber cannot be more than 10 digits' do
    @user_valid.phoneNumber = "12345678912"
    assert_not @user_valid.valid?
  end

  test 'number cannot be a negative number' do
    @user_valid.phoneNumber = "-12345678910"
    assert_not @user_valid.valid?
  end

  test 'phoneNumber can be 9 digits' do
    @user_valid.phoneNumber = "123456789"
    assert @user_valid.valid?
  end

  test 'phoneNumber can be 10 digits' do
    @user_valid.phoneNumber = "1234567891"
    assert @user_valid.valid?
  end

  # First name tests

  test 'fname can be 2 characters long' do
    @user_valid.fname = "Al"
    assert @user_valid.valid?
  end

  test 'fname can be 26 characters long' do
    @user_valid.fname = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    assert @user_valid.valid?
  end

  test 'fname cannot be less than 2 characters long' do
    @user_valid.fname = "A"
    assert_not @user_valid.valid?
  end

  test 'fname cannot be more than 26 characters long' do
    @user_valid.fname = "ABCDEFGHIJKLMNOPQRSTUVWXYZa"
    assert_not @user_valid.valid?
  end

  # Last name tests

  test 'lname can be 2 characters long' do
    @user_valid.lname = "Al"
    assert @user_valid.valid?
  end

  test 'lname can be 26 characters long' do
    @user_valid.lname = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    assert @user_valid.valid?
  end

  test 'lname cannot be less than 2 characters long' do
    @user_valid.lname = "A"
    assert_not @user_valid.valid?
  end

  test 'lname cannot be more than 26 characters long' do
    @user_valid.lname = "ABCDEFGHIJKLMNOPQRSTUVWXYZa"
    assert_not @user_valid.valid?
  end

  # Email tests

  test 'email should be valid' do
    @user_valid.email = 'blah'
    assert_not @user_valid.valid?
  end

  test 'email regular expression matching should be valid' do
    @user_valid.email = 'something@something.com'
    assert @user_valid.valid?
  end

  test 'emails should be unique' do
    duplicate_user = @user_valid.dup
    duplicate_user.username = 'Something Else'
    duplicate_user.email = duplicate_user.email.upcase
    @user_valid.save
    assert_not duplicate_user.valid?
  end

end
