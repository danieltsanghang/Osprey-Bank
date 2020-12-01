require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "sort code has 6 digits" do
    account = Account.new(:user_id => 1, :sortCode => 123456, :accountNumber => 12345678)
    assert account.valid?
  end

  test "sort code does not have 6 digits" do
    account = Account.new(:user_id => 1, :sortCode => 12345, :accountNumber => 12345678)
    assert_not account.valid?
  end

  test "account number is within range 8..9" do
    account = Account.new(:user_id => 1, :sortCode => 123456, :accountNumber => 12345678)
    assert account.valid?
  end

  test "account number is not within range 8..9" do
    account = Account.new(:user_id => 1, :sortCode => 123456, :accountNumber => 1234567)
    assert_not account.valid?
  end

  
end
